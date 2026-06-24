package config

import (
	"os"
)

type Config struct {
	Port           string
	Host           string
	DatabaseURL    string
	JWTSecret      string
	AllowedOrigins string
}

func Load() *Config {
	return &Config{
		Port:           getEnv("PORT", "8080"),
		Host:           getEnv("HOST", "0.0.0.0"),
		DatabaseURL:    getEnv("DATABASE_URL", "postgres://okresownik:okresownik@localhost:5432/okresownik?sslmode=disable"),
		JWTSecret:      getEnv("JWT_SECRET", "change-me-in-production"),
		AllowedOrigins: getEnv("ALLOWED_ORIGINS", "*"),
	}
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
