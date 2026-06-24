package main

import (
	"fmt"
	"log"
	"net/http"

	"okresownik/config"
	_ "okresownik/docs"
	"okresownik/internal/database"
	"okresownik/internal/handlers"
	"okresownik/internal/middleware"
	"okresownik/internal/services"

	httpSwagger "github.com/swaggo/http-swagger"
)

// @title Okresownik API
// @version 1.0
// @description REST API for Okresownik.
// @host api.okresownik.pl
// @BasePath /
// @schemes https
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @description Type "Bearer" followed by a space and a JWT.
func main() {
	cfg := config.Load()

	db := database.Connect(cfg.DatabaseURL)
	database.Migrate()

	authService := services.NewAuthService(db, cfg.JWTSecret)
	cycleService := services.NewCycleService(db)
	partnerService := services.NewPartnerService(db)

	authHandler := handlers.NewAuthHandler(authService)
	cycleHandler := handlers.NewCycleHandler(cycleService)
	partnerHandler := handlers.NewPartnerHandler(partnerService)

	mux := http.NewServeMux()
	mux.HandleFunc("/health", healthHandler)
	mux.Handle("/swagger/", httpSwagger.WrapHandler)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		middleware.WriteError(w, http.StatusNotFound, "not found")
	})

	mux.HandleFunc("/api/auth/register", authHandler.Register)
	mux.HandleFunc("/api/auth/login", authHandler.Login)

	protected := http.NewServeMux()
	protected.HandleFunc("/api/cycle/days", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			cycleHandler.GetDays(w, r)
		case http.MethodPost:
			cycleHandler.UpsertDay(w, r)
		default:
			middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
		}
	})
	protected.HandleFunc("/api/cycle/days/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodDelete {
			cycleHandler.DeleteDay(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})
	protected.HandleFunc("/api/cycle/predictions", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			cycleHandler.GetPrediction(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})

	protected.HandleFunc("/api/partner/code", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			partnerHandler.GetPartnerCode(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})
	protected.HandleFunc("/api/partner/code/regenerate", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			partnerHandler.RegeneratePartnerCode(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})
	protected.HandleFunc("/api/partner/link", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			partnerHandler.LinkToPartner(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})
	protected.HandleFunc("/api/partner/unlink", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			partnerHandler.UnlinkPartner(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})
	protected.HandleFunc("/api/partner/view", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			partnerHandler.GetPartnerView(w, r)
			return
		}
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
	})

	authMw := middleware.AuthMiddleware(cfg.JWTSecret)
	mux.Handle("/api/cycle/", authMw(middleware.JSON(protected)))
	mux.Handle("/api/partner/", authMw(middleware.JSON(protected)))

	handler := middleware.CORSMiddleware(cfg.AllowedOrigins)(middleware.JSON(mux))

	addr := fmt.Sprintf("%s:%s", cfg.Host, cfg.Port)
	log.Printf("server starting on %s", addr)
	if err := http.ListenAndServe(addr, handler); err != nil {
		log.Fatalf("server failed: %v", err)
	}
}

type healthResponse struct {
	Status string `json:"status"`
}

// healthHandler godoc
// @Summary Health check
// @Description Returns service health status.
// @Tags health
// @Produce json
// @Success 200 {object} healthResponse
// @Failure 405 {object} handlers.ErrorResponse
// @Router /health [get]
func healthHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		middleware.WriteError(w, http.StatusMethodNotAllowed, "method not allowed")
		return
	}
	middleware.WriteJSON(w, http.StatusOK, healthResponse{Status: "ok"})
}
