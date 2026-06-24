package handlers

import (
	"encoding/json"
	"net/http"

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
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
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
	ID          uint   `json:"id"`
	Email       string `json:"email"`
	Name        string `json:"name"`
	PartnerCode string `json:"partnerCode"`
	PartnerID   *uint  `json:"partnerId"`
}

func toUserResponse(user *models.User) userResponse {
	return userResponse{
		ID:          user.ID,
		Email:       user.Email,
		Name:        user.Name,
		PartnerCode: user.PartnerCode,
		PartnerID:   user.PartnerID,
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

	user, token, err := h.AuthService.Register(req.Email, req.Password, req.Name)
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
