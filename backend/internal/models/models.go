package models

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	ID           uint           `gorm:"primaryKey" json:"id"`
	CreatedAt    time.Time      `json:"createdAt"`
	UpdatedAt    time.Time      `json:"updatedAt"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"deletedAt,omitempty"`
	Email        string         `gorm:"uniqueIndex;not null" json:"email"`
	PasswordHash string         `gorm:"not null" json:"-"`
	Name         string         `gorm:"not null" json:"name"`
	PartnerCode  string         `gorm:"uniqueIndex;not null" json:"partnerCode"`
	PartnerID    *uint          `json:"partnerId,omitempty"`
	Partner      *User          `gorm:"foreignKey:PartnerID" json:"partner,omitempty"`
	CycleDays    []CycleDay     `json:"cycleDays,omitempty"`

	TermsAcceptedAt   *time.Time `json:"termsAcceptedAt,omitempty"`
	PrivacyAcceptedAt *time.Time `json:"privacyAcceptedAt,omitempty"`
	ConsentGrantedAt  *time.Time `json:"consentGrantedAt,omitempty"`
}

type FlowLevel string

const (
	FlowSpotting FlowLevel = "spotting"
	FlowLight    FlowLevel = "light"
	FlowMedium   FlowLevel = "medium"
	FlowHeavy    FlowLevel = "heavy"
)

type CycleDay struct {
	ID            uint           `gorm:"primaryKey" json:"id"`
	CreatedAt     time.Time      `json:"createdAt"`
	UpdatedAt     time.Time      `json:"updatedAt"`
	DeletedAt     gorm.DeletedAt `gorm:"index" json:"deletedAt,omitempty"`
	UserID        uint           `gorm:"index:idx_user_date,unique;not null" json:"userId"`
	Date          time.Time      `gorm:"index:idx_user_date,unique;not null" json:"date"`
	IsPeriod      bool           `gorm:"default:false" json:"isPeriod"`
	IsIntercourse bool           `gorm:"default:false" json:"isIntercourse"`
	Flow          FlowLevel      `gorm:"type:varchar(20);default:''" json:"flow"`
	Notes         string         `gorm:"type:text" json:"notes"`
}

type Prediction struct {
	NextPeriodStart       time.Time `json:"nextPeriodStart"`
	NextPeriodEnd         time.Time `json:"nextPeriodEnd"`
	OvulationDate         time.Time `json:"ovulationDate"`
	FertileWindowStart    time.Time `json:"fertileWindowStart"`
	FertileWindowEnd      time.Time `json:"fertileWindowEnd"`
	AverageCycleLength    float64   `json:"averageCycleLength"`
	AveragePeriodDuration float64   `json:"averagePeriodDuration"`
	CycleDay              int       `json:"cycleDay"`
	Confidence            string    `json:"confidence"`
}

type PartnerCalendarResponse struct {
	User       User        `json:"user"`
	CycleDays  []CycleDay  `json:"cycleDays"`
	Prediction *Prediction `json:"prediction,omitempty"`
}
