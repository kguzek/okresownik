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
