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
	Date          string           `json:"date"`
	IsPeriod      bool             `json:"isPeriod"`
	IsIntercourse bool             `json:"isIntercourse"`
	Flow          models.FlowLevel `json:"flow"`
	Notes         string           `json:"notes"`
}

type dayResponse struct {
	ID            uint             `json:"id"`
	Date          string           `json:"date"`
	IsPeriod      bool             `json:"isPeriod"`
	IsIntercourse bool             `json:"isIntercourse"`
	Flow          models.FlowLevel `json:"flow"`
	Notes         string           `json:"notes"`
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

// GetDays godoc
// @Summary List cycle days
// @Description Lists cycle days for the authenticated user.
// @Tags cycle
// @Produce json
// @Security BearerAuth
// @Param from query string false "Start date in YYYY-MM-DD format"
// @Param to query string false "End date in YYYY-MM-DD format"
// @Success 200 {array} dayResponse
// @Failure 401 {object} ErrorResponse
// @Failure 500 {object} ErrorResponse
// @Router /api/cycle/days [get]
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

// UpsertDay godoc
// @Summary Create or update cycle day
// @Description Creates or updates a cycle day for the authenticated user.
// @Tags cycle
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body upsertDayRequest true "Cycle day data"
// @Success 200 {object} dayResponse
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Failure 500 {object} ErrorResponse
// @Router /api/cycle/days [post]
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

// DeleteDay godoc
// @Summary Delete cycle day
// @Description Deletes a cycle day by ID for the authenticated user.
// @Tags cycle
// @Security BearerAuth
// @Param id path int true "Cycle day ID"
// @Success 204
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Failure 404 {object} ErrorResponse
// @Router /api/cycle/days/{id} [delete]
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

// GetPrediction godoc
// @Summary Get cycle predictions
// @Description Returns cycle predictions for the authenticated user.
// @Tags cycle
// @Produce json
// @Security BearerAuth
// @Success 200 {object} models.Prediction
// @Failure 401 {object} ErrorResponse
// @Failure 500 {object} ErrorResponse
// @Router /api/cycle/predictions [get]
func (h *CycleHandler) GetPrediction(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)

	prediction, err := h.CycleService.GetPrediction(userID)
	if err != nil {
		writeError(w, "failed to generate prediction", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, prediction)
}
