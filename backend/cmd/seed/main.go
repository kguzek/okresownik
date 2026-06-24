package main

import (
	"fmt"
	"log"
	"math/rand"
	"time"

	"okresownik/config"
	"okresownik/internal/database"
	"okresownik/internal/models"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func main() {
	cfg := config.Load()
	db := database.Connect(cfg.DatabaseURL)
	database.Migrate()

	passwordHash, err := bcrypt.GenerateFromPassword([]byte("password123"), bcrypt.DefaultCost)
	if err != nil {
		log.Fatalf("failed to hash password: %v", err)
	}

	anna := models.User{
		Email:        "anna@okresownik.pl",
		PasswordHash: string(passwordHash),
		Name:         "Anna",
		PartnerCode:  "ANNA01",
	}
	jan := models.User{
		Email:        "jan@okresownik.pl",
		PasswordHash: string(passwordHash),
		Name:         "Jan",
		PartnerCode:  "JANX01",
	}
	zofia := models.User{
		Email:        "zofia@okresownik.pl",
		PasswordHash: string(passwordHash),
		Name:         "Zofia",
		PartnerCode:  "ZOFI01",
	}

	db.Where("email = ?", anna.Email).FirstOrCreate(&anna)
	db.Where("email = ?", jan.Email).FirstOrCreate(&jan)
	db.Where("email = ?", zofia.Email).FirstOrCreate(&zofia)

	anna.PartnerID = &jan.ID
	jan.PartnerID = &anna.ID
	db.Save(&anna)
	db.Save(&jan)

	db.Unscoped().Where("user_id IN (?)", []uint{anna.ID, jan.ID, zofia.ID}).Delete(&models.CycleDay{})

	seedCycleDataForUser(db, anna.ID, time.Date(2026, 1, 5, 0, 0, 0, 0, time.UTC), 7, 5, 28)
	seedCycleDataForUser(db, zofia.ID, time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC), 6, 4, 30)

	seedIntercourseDays(db, anna.ID)

	fmt.Println("seed completed successfully")
	fmt.Println()
	fmt.Println("Demo accounts (password: password123):")
	fmt.Printf("  Anna (has partner Jan): %s\n", anna.Email)
	fmt.Printf("  Jan (partner of Anna):  %s\n", jan.Email)
	fmt.Printf("  Zofia (no partner):     %s\n", zofia.Email)
	fmt.Println()
	fmt.Printf("Anna's partner code: %s\n", anna.PartnerCode)
	fmt.Printf("Jan's partner code:  %s\n", jan.PartnerCode)
	fmt.Printf("Zofia's partner code: %s\n", zofia.PartnerCode)
}

func seedCycleDataForUser(db *gorm.DB, userID uint, start time.Time, numCycles int, periodDuration int, cycleLength int) {
	currentStart := start
	rng := rand.New(rand.NewSource(int64(userID) + 42))

	for cycle := 0; cycle < numCycles; cycle++ {
		actualLength := cycleLength + rng.Intn(3) - 1
		if actualLength < 21 {
			actualLength = 21
		}
		if actualLength > 42 {
			actualLength = 42
		}

		actualDuration := periodDuration + rng.Intn(3) - 1
		if actualDuration < 2 {
			actualDuration = 2
		}
		if actualDuration > 8 {
			actualDuration = 8
		}

		for day := 0; day < actualDuration; day++ {
			date := currentStart.AddDate(0, 0, day)
			flow := randomFlow(rng, day, actualDuration)

			cycleDay := models.CycleDay{
				UserID:   userID,
				Date:     date,
				IsPeriod: true,
				Flow:     flow,
			}
			db.FirstOrCreate(&cycleDay, models.CycleDay{UserID: userID, Date: date})
		}

		currentStart = currentStart.AddDate(0, 0, actualLength)
	}
}

func seedIntercourseDays(db *gorm.DB, userID uint) {
	rng := rand.New(rand.NewSource(99))

	baseDate := time.Date(2026, 1, 10, 0, 0, 0, 0, time.UTC)
	for i := 0; i < 12; i++ {
		date := baseDate.AddDate(0, 0, i*10+rng.Intn(5))
		if date.After(time.Now()) {
			break
		}

		intercourseDay := models.CycleDay{
			UserID:        userID,
			Date:          date,
			IsIntercourse: true,
		}
		db.FirstOrCreate(&intercourseDay, models.CycleDay{UserID: userID, Date: date})
	}
}

func randomFlow(rng *rand.Rand, day int, duration int) models.FlowLevel {
	if day == 0 || day == duration-1 {
		options := []models.FlowLevel{models.FlowSpotting, models.FlowLight}
		return options[rng.Intn(len(options))]
	}
	if day == 1 || day == duration-2 {
		options := []models.FlowLevel{models.FlowLight, models.FlowMedium}
		return options[rng.Intn(len(options))]
	}
	options := []models.FlowLevel{models.FlowMedium, models.FlowHeavy}
	return options[rng.Intn(len(options))]
}
