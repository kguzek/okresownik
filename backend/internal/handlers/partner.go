package handlers

import (
	"encoding/json"
	"net/http"

	"okresownik/internal/middleware"
	"okresownik/internal/services"
)

type PartnerHandler struct {
	PartnerService *services.PartnerService
}

func NewPartnerHandler(partnerService *services.PartnerService) *PartnerHandler {
	return &PartnerHandler{PartnerService: partnerService}
}

type linkRequest struct {
	PartnerCode string `json:"partnerCode"`
}

type partnerCodeResponse struct {
	PartnerCode string `json:"partnerCode"`
}

func (h *PartnerHandler) GetPartnerCode(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	code, err := h.PartnerService.GetPartnerCode(userID)
	if err != nil {
		writeError(w, "failed to get partner code", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, partnerCodeResponse{PartnerCode: code})
}

func (h *PartnerHandler) RegeneratePartnerCode(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	code, err := h.PartnerService.RegeneratePartnerCode(userID)
	if err != nil {
		writeError(w, "failed to regenerate partner code", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, partnerCodeResponse{PartnerCode: code})
}

func (h *PartnerHandler) LinkToPartner(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	var req linkRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, "invalid request body", http.StatusBadRequest)
		return
	}

	if err := h.PartnerService.LinkToPartner(userID, req.PartnerCode); err != nil {
		status := http.StatusBadRequest
		switch err {
		case services.ErrPartnerCodeInvalid:
			status = http.StatusNotFound
		case services.ErrAlreadyHasPartner, services.ErrPartnerAlreadyLinked:
			status = http.StatusConflict
		}
		writeError(w, err.Error(), status)
		return
	}

	w.WriteHeader(http.StatusOK)
	writeJSON(w, http.StatusOK, map[string]string{"message": "partner linked successfully"})
}

func (h *PartnerHandler) UnlinkPartner(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	if err := h.PartnerService.UnlinkPartner(userID); err != nil {
		status := http.StatusBadRequest
		if err == services.ErrNoPartnerLinked {
			status = http.StatusNotFound
		}
		writeError(w, err.Error(), status)
		return
	}

	writeJSON(w, http.StatusOK, map[string]string{"message": "partner unlinked successfully"})
}

func (h *PartnerHandler) GetPartnerView(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	view, err := h.PartnerService.GetPartnerView(userID)
	if err != nil {
		status := http.StatusBadRequest
		if err == services.ErrNoPartnerLinked {
			status = http.StatusNotFound
		}
		writeError(w, err.Error(), status)
		return
	}

	writeJSON(w, http.StatusOK, view)
}
