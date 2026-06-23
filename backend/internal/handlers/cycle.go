package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"okresownik/internal/middleware"
	"okresownik/internal/models"
	"okresownik/internal/services"
)

type CycleHandler struct {
	CycleService *services.CycleService
}

func NewCycleHandler(cycleService *services.CycleService) *CycleHandler {
	return &CycleHandler{CycleService: cycleService}
}

type upsertDayRequest struct {
	Date          string          `json:"date"`
	IsPeriod      bool            `json:"isPeriod"`
	IsIntercourse bool            `json:"isIntercourse"`
	Flow          models.FlowLevel `json:"flow"`
	Notes         string          `json:"notes"`
}

type dayResponse struct {
	ID            uint            `json:"id"`
	Date          string          `json:"date"`
	IsPeriod      bool            `json:"isPeriod"`
	IsIntercourse bool            `json:"isIntercourse"`
	Flow          models.FlowLevel `json:"flow"`
	Notes         string          `json:"notes"`
}

func toDayResponse(day *models.CycleDay) dayResponse {
	return dayResponse{
		ID:            day.ID,
		Date:          day.Date.Format("2006-01-02"),
		IsPeriod:      day.IsPeriod,
		IsIntercourse: day.IsIntercourse,
		Flow:          day.Flow,
		Notes:         day.Notes,
	}
}

func (h *CycleHandler) GetDays(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	fromStr := r.URL.Query().Get("from")
	toStr := r.URL.Query().Get("to")

	var from, to time.Time
	if fromStr != "" {
		parsed, err := time.Parse("2006-01-02", fromStr)
		if err == nil {
			from = parsed
		}
	}
	if toStr != "" {
		parsed, err := time.Parse("2006-01-02", toStr)
		if err == nil {
			to = parsed
		}
	}

	days, err := h.CycleService.GetDays(userID, from, to)
	if err != nil {
		writeError(w, "failed to fetch cycle days", http.StatusInternalServerError)
		return
	}

	responses := make([]dayResponse, 0, len(days))
	for _, d := range days {
		responses = append(responses, toDayResponse(&d))
	}

	writeJSON(w, http.StatusOK, responses)
}

func (h *CycleHandler) UpsertDay(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	var req upsertDayRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, "invalid request body", http.StatusBadRequest)
		return
	}

	date, err := time.Parse("2006-01-02", req.Date)
	if err != nil {
		writeError(w, "invalid date format, use YYYY-MM-DD", http.StatusBadRequest)
		return
	}

	day, err := h.CycleService.UpsertDay(userID, date, req.IsPeriod, req.IsIntercourse, req.Flow, req.Notes)
	if err != nil {
		writeError(w, "failed to save cycle day", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, toDayResponse(day))
}

func (h *CycleHandler) DeleteDay(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	idStr := strings.TrimPrefix(r.URL.Path, "/api/cycle/days/")
	dayID, err := strconv.ParseUint(idStr, 10, 64)
	if err != nil {
		writeError(w, "invalid day id", http.StatusBadRequest)
		return
	}

	if err := h.CycleService.DeleteDay(userID, uint(dayID)); err != nil {
		writeError(w, err.Error(), http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *CycleHandler) GetPrediction(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	prediction, err := h.CycleService.GetPrediction(userID)
	if err != nil {
		writeError(w, "failed to generate prediction", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, prediction)
}
