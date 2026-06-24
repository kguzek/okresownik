package services

import (
	"errors"
	"time"

	"okresownik/internal/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type CycleService struct {
	DB *gorm.DB
}

func NewCycleService(db *gorm.DB) *CycleService {
	return &CycleService{DB: db}
}

func (s *CycleService) GetDays(userID uint, from, to time.Time) ([]models.CycleDay, error) {
	var days []models.CycleDay
	query := s.DB.Where("user_id = ?", userID)

	if !from.IsZero() {
		query = query.Where("date >= ?", from)
	}
	if !to.IsZero() {
		query = query.Where("date <= ?", to)
	}

	if err := query.Order("date ASC").Find(&days).Error; err != nil {
		return nil, err
	}

	return days, nil
}

func (s *CycleService) UpsertDay(userID uint, date time.Time, isPeriod bool, isIntercourse bool, flow models.FlowLevel, notes string) (*models.CycleDay, error) {
	date = date.Truncate(24 * time.Hour)

	day := models.CycleDay{
		UserID:        userID,
		Date:          date,
		IsPeriod:      isPeriod,
		IsIntercourse: isIntercourse,
		Flow:          flow,
		Notes:         notes,
	}

	err := s.DB.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "user_id"}, {Name: "date"}},
		DoUpdates: clause.AssignmentColumns([]string{"is_period", "is_intercourse", "flow", "notes", "updated_at", "deleted_at"}),
	}).Create(&day).Error

	if err != nil {
		return nil, err
	}

	// Reload to get the full record (includes auto-updated timestamp)
	s.DB.Where("user_id = ? AND date = ?", userID, date).First(&day)
	return &day, nil
}

func (s *CycleService) DeleteDay(userID uint, dayID uint) error {
	result := s.DB.Where("id = ? AND user_id = ?", dayID, userID).Delete(&models.CycleDay{})
	if result.RowsAffected == 0 {
		return errors.New("cycle day not found")
	}
	return result.Error
}

func (s *CycleService) GetPrediction(userID uint) (*models.Prediction, error) {
	var periodDays []models.CycleDay
	if err := s.DB.Where("user_id = ? AND is_period = true", userID).
		Order("date ASC").
		Find(&periodDays).Error; err != nil {
		return nil, err
	}

	return CalculatePrediction(periodDays)
}
