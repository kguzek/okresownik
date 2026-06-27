package services

import (
	"crypto/rand"
	"encoding/hex"
	"errors"
	"regexp"
	"strings"
	"time"

	"okresownik/internal/middleware"
	"okresownik/internal/models"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

var (
	ErrEmailTaken         = errors.New("email already registered")
	ErrInvalidEmail       = errors.New("invalid email format")
	ErrInvalidPassword    = errors.New("password must be at least 8 characters")
	ErrInvalidName        = errors.New("name is required")
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrTermsNotAccepted   = errors.New("you must accept the Terms of Service")
	ErrPrivacyNotAccepted = errors.New("you must accept the Privacy Policy")
	ErrConsentNotGranted  = errors.New("you must consent to data processing")
	ErrUserNotFound       = errors.New("user not found")
)

type AuthService struct {
	DB        *gorm.DB
	JWTSecret string
}

func NewAuthService(db *gorm.DB, jwtSecret string) *AuthService {
	return &AuthService{
		DB:        db,
		JWTSecret: jwtSecret,
	}
}

func (s *AuthService) Register(email, password, name string, termsAccepted, privacyAccepted, consentGranted bool) (*models.User, string, error) {
	email = strings.TrimSpace(strings.ToLower(email))
	name = strings.TrimSpace(name)

	if name == "" {
		return nil, "", ErrInvalidName
	}

	emailRegex := regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)
	if !emailRegex.MatchString(email) {
		return nil, "", ErrInvalidEmail
	}

	if len(password) < 8 {
		return nil, "", ErrInvalidPassword
	}

	if !termsAccepted {
		return nil, "", ErrTermsNotAccepted
	}
	if !privacyAccepted {
		return nil, "", ErrPrivacyNotAccepted
	}
	if !consentGranted {
		return nil, "", ErrConsentNotGranted
	}

	var existing models.User
	if err := s.DB.Where("email = ?", email).First(&existing).Error; err == nil {
		return nil, "", ErrEmailTaken
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, "", err
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, "", err
	}

	partnerCode, err := generatePartnerCode()
	if err != nil {
		return nil, "", err
	}

	now := time.Now()
	user := models.User{
		Email:             email,
		PasswordHash:      string(hashedPassword),
		Name:              name,
		PartnerCode:       partnerCode,
		TermsAcceptedAt:   &now,
		PrivacyAcceptedAt: &now,
		ConsentGrantedAt:  &now,
	}

	if err := s.DB.Create(&user).Error; err != nil {
		return nil, "", err
	}

	token, err := middleware.GenerateToken(user.ID, s.JWTSecret)
	if err != nil {
		return nil, "", err
	}

	return &user, token, nil
}

func (s *AuthService) Login(email, password string) (*models.User, string, error) {
	email = strings.TrimSpace(strings.ToLower(email))

	var user models.User
	if err := s.DB.Where("email = ?", email).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, "", ErrInvalidCredentials
		}
		return nil, "", err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return nil, "", ErrInvalidCredentials
	}

	token, err := middleware.GenerateToken(user.ID, s.JWTSecret)
	if err != nil {
		return nil, "", err
	}

	return &user, token, nil
}

func (s *AuthService) AcceptTerms(userID uint) error {
	now := time.Now()
	return s.DB.Model(&models.User{}).Where("id = ?", userID).Updates(map[string]interface{}{
		"terms_accepted_at":   &now,
		"privacy_accepted_at": &now,
		"consent_granted_at":  &now,
	}).Error
}

func (s *AuthService) DeleteData(userID uint) error {
	return s.DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("user_id = ?", userID).Delete(&models.CycleDay{}).Error; err != nil {
			return err
		}
		if err := tx.Model(&models.User{}).Where("id = ?", userID).Updates(map[string]interface{}{
			"partner_id": nil,
		}).Error; err != nil {
			return err
		}
		return nil
	})
}

func (s *AuthService) DeleteAccount(userID uint) error {
	return s.DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("user_id = ?", userID).Delete(&models.CycleDay{}).Error; err != nil {
			return err
		}
		if err := tx.Where("partner_id = ?", userID).Update("partner_id", nil).Error; err != nil {
			return err
		}
		if err := tx.Where("id = ?", userID).Delete(&models.User{}).Error; err != nil {
			return err
		}
		return nil
	})
}

func generatePartnerCode() (string, error) {
	bytes := make([]byte, 4)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return strings.ToUpper(hex.EncodeToString(bytes)), nil
}
