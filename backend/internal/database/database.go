package database

import (
	"fmt"
	"log"

	"okresownik/internal/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

func Connect(databaseURL string) *gorm.DB {
	var err error
	DB, err = gorm.Open(postgres.Open(databaseURL), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}

	sqlDB, err := DB.DB()
	if err != nil {
		log.Fatalf("failed to get underlying sql.DB: %v", err)
	}

	if err := sqlDB.Ping(); err != nil {
		log.Fatalf("failed to ping database: %v", err)
	}

	fmt.Println("connected to database successfully")
	return DB
}

func Migrate() {
	if err := DB.AutoMigrate(
		&models.User{},
		&models.CycleDay{},
	); err != nil {
		log.Fatalf("failed to run migrations: %v", err)
	}
	fmt.Println("database migrations completed")
}
