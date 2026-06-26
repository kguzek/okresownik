package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"okresownik/internal/middleware"
	"okresownik/internal/models"
	"okresownik/internal/services"
)

type AuthHandler struct {
	AuthService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{AuthService: authService}
}

type registerRequest struct {
	Email           string `json:"email"`
	Password        string `json:"password"`
	Name            string `json:"name"`
	TermsAccepted   bool   `json:"termsAccepted"`
	PrivacyAccepted bool   `json:"privacyAccepted"`
	ConsentGranted  bool   `json:"consentGranted"`
}

type loginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type authResponse struct {
	User  userResponse `json:"user"`
	Token string       `json:"token"`
}

type userResponse struct {
	ID                uint       `json:"id"`
	Email             string     `json:"email"`
	Name              string     `json:"name"`
	PartnerCode       string     `json:"partnerCode"`
	PartnerID         *uint      `json:"partnerId"`
	TermsAcceptedAt   *time.Time `json:"termsAcceptedAt,omitempty"`
	PrivacyAcceptedAt *time.Time `json:"privacyAcceptedAt,omitempty"`
	ConsentGrantedAt  *time.Time `json:"consentGrantedAt,omitempty"`
}

func toUserResponse(user *models.User) userResponse {
	return userResponse{
		ID:                user.ID,
		Email:             user.Email,
		Name:              user.Name,
		PartnerCode:       user.PartnerCode,
		PartnerID:         user.PartnerID,
		TermsAcceptedAt:   user.TermsAcceptedAt,
		PrivacyAcceptedAt: user.PrivacyAcceptedAt,
		ConsentGrantedAt:  user.ConsentGrantedAt,
	}
}

// Register godoc
// @Summary Register user
// @Description Creates a user account and returns the user plus JWT.
// @Tags auth
// @Accept json
// @Produce json
// @Param request body registerRequest true "Registration data"
// @Success 201 {object} authResponse
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Failure 405 {object} ErrorResponse
// @Failure 409 {object} ErrorResponse
// @Router /api/auth/register [post]
func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeError(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req registerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, "invalid request body", http.StatusBadRequest)
		return
	}

	user, token, err := h.AuthService.Register(req.Email, req.Password, req.Name, req.TermsAccepted, req.PrivacyAccepted, req.ConsentGranted)
	if err != nil {
		status := http.StatusBadRequest
		switch err {
		case services.ErrEmailTaken:
			status = http.StatusConflict
		case services.ErrInvalidCredentials:
			status = http.StatusUnauthorized
		}
		writeError(w, err.Error(), status)
		return
	}

	writeJSON(w, http.StatusCreated, authResponse{
		User:  toUserResponse(user),
		Token: token,
	})
}

// Login godoc
// @Summary Log in
// @Description Authenticates a user and returns the user plus JWT.
// @Tags auth
// @Accept json
// @Produce json
// @Param request body loginRequest true "Login credentials"
// @Success 200 {object} authResponse
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Failure 405 {object} ErrorResponse
// @Router /api/auth/login [post]
func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeError(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req loginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, "invalid request body", http.StatusBadRequest)
		return
	}

	user, token, err := h.AuthService.Login(req.Email, req.Password)
	if err != nil {
		writeError(w, err.Error(), http.StatusUnauthorized)
		return
	}

	writeJSON(w, http.StatusOK, authResponse{
		User:  toUserResponse(user),
		Token: token,
	})
}

// AcceptTerms godoc
// @Summary Accept ToS, Privacy Policy, and data processing consent
// @Description Records acceptance of legal documents for existing users.
// @Tags auth
// @Accept json
// @Produce json
// @Success 200 {object} map[string]string
// @Failure 401 {object} ErrorResponse
// @Router /api/auth/accept-terms [post]
func (h *AuthHandler) AcceptTerms(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeError(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	userID := middleware.GetUserID(r)
	if err := h.AuthService.AcceptTerms(userID); err != nil {
		writeError(w, "failed to record acceptance", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, map[string]string{"status": "accepted"})
}

// DeleteData godoc
// @Summary Delete all user data but keep account
// @Description Deletes all cycle data while keeping the user account.
// @Tags auth
// @Accept json
// @Produce json
// @Success 200 {object} map[string]string
// @Failure 401 {object} ErrorResponse
// @Router /api/auth/delete-data [post]
func (h *AuthHandler) DeleteData(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeError(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	userID := middleware.GetUserID(r)
	if err := h.AuthService.DeleteData(userID); err != nil {
		writeError(w, "failed to delete data", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, map[string]string{"status": "deleted"})
}

// DeleteAccount godoc
// @Summary Delete account and all data
// @Description Permanently deletes the user account and all associated data.
// @Tags auth
// @Accept json
// @Produce json
// @Success 200 {object} map[string]string
// @Failure 401 {object} ErrorResponse
// @Router /api/auth/delete-account [post]
func (h *AuthHandler) DeleteAccount(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeError(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	userID := middleware.GetUserID(r)
	if err := h.AuthService.DeleteAccount(userID); err != nil {
		writeError(w, "failed to delete account", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, map[string]string{"status": "deleted"})
}
