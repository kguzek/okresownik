package services

import (
	"errors"
	"time"

	"okresownik/internal/models"

	"gorm.io/gorm"
)

var (
	ErrPartnerCodeInvalid   = errors.New("invalid partner code")
	ErrCannotPartnerSelf    = errors.New("cannot partner with yourself")
	ErrAlreadyHasPartner    = errors.New("user already has a partner")
	ErrPartnerAlreadyLinked = errors.New("target user already has a partner")
	ErrNoPartnerLinked      = errors.New("no partner linked")
)

type PartnerService struct {
	DB *gorm.DB
}

func NewPartnerService(db *gorm.DB) *PartnerService {
	return &PartnerService{DB: db}
}

func (s *PartnerService) GetPartnerCode(userID uint) (string, error) {
	var user models.User
	if err := s.DB.First(&user, userID).Error; err != nil {
		return "", err
	}
	return user.PartnerCode, nil
}

func (s *PartnerService) RegeneratePartnerCode(userID uint) (string, error) {
	newCode, err := generatePartnerCode()
	if err != nil {
		return "", err
	}

	if err := s.DB.Model(&models.User{}).Where("id = ?", userID).
		Update("partner_code", newCode).Error; err != nil {
		return "", err
	}

	return newCode, nil
}

func (s *PartnerService) LinkToPartner(userID uint, partnerCode string) error {
	var partner models.User
	if err := s.DB.Where("partner_code = ?", partnerCode).First(&partner).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ErrPartnerCodeInvalid
		}
		return err
	}

	if partner.ID == userID {
		return ErrCannotPartnerSelf
	}

	var currentUser models.User
	if err := s.DB.First(&currentUser, userID).Error; err != nil {
		return err
	}

	if currentUser.PartnerID != nil {
		var partner models.User
		if err := s.DB.First(&partner, *currentUser.PartnerID).Error; err == nil {
			if partner.PartnerID != nil && *partner.PartnerID == userID {
				if err := s.DB.Model(&partner).Update("partner_id", nil).Error; err != nil {
					return err
				}
			}
		}
	}

	if partner.PartnerID != nil {
		return ErrPartnerAlreadyLinked
	}

	tx := s.DB.Begin()

	if err := tx.Model(&models.User{}).Where("id = ?", userID).
		Update("partner_id", partner.ID).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Model(&models.User{}).Where("id = ?", partner.ID).
		Update("partner_id", userID).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

func (s *PartnerService) UnlinkPartner(userID uint) error {
	var user models.User
	if err := s.DB.First(&user, userID).Error; err != nil {
		return err
	}

	if user.PartnerID == nil {
		return ErrNoPartnerLinked
	}

	tx := s.DB.Begin()

	if err := tx.Model(&models.User{}).Where("id = ?", userID).
		Update("partner_id", nil).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Model(&models.User{}).Where("id = ?", *user.PartnerID).
		Update("partner_id", nil).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

func (s *PartnerService) GetPartnerView(userID uint) (*models.PartnerCalendarResponse, error) {
	var user models.User
	if err := s.DB.First(&user, userID).Error; err != nil {
		return nil, err
	}

	if user.PartnerID == nil {
		return nil, ErrNoPartnerLinked
	}

	var partner models.User
	if err := s.DB.First(&partner, *user.PartnerID).Error; err != nil {
		return nil, err
	}

	var cycleDays []models.CycleDay
	if err := s.DB.Where("user_id = ? AND (is_period = true OR is_intercourse = true)", partner.ID).
		Order("date ASC").Find(&cycleDays).Error; err != nil {
		return nil, err
	}

	var prediction *models.Prediction
	pred, err := CalculatePrediction(cycleDays)
	if err == nil {
		prediction = pred
	}

	var partnerUser models.User
	s.DB.First(&partnerUser, partner.ID)

	now := time.Now()
	threeMonthsAgo := now.AddDate(0, -3, 0)
	var recentDays []models.CycleDay
	for _, d := range cycleDays {
		if !d.Date.Before(threeMonthsAgo) {
			recentDays = append(recentDays, d)
		}
	}

	partnerUser.PasswordHash = ""

	return &models.PartnerCalendarResponse{
		User:       partnerUser,
		CycleDays:  recentDays,
		Prediction: prediction,
	}, nil
}
