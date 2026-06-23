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

	alice := models.User{
		Email:        "alice@example.com",
		PasswordHash: string(passwordHash),
		Name:         "Alice",
		PartnerCode:  "ALIC01",
	}
	bob := models.User{
		Email:        "bob@example.com",
		PasswordHash: string(passwordHash),
		Name:         "Bob",
		PartnerCode:  "BOBX01",
	}
	carol := models.User{
		Email:        "carol@example.com",
		PasswordHash: string(passwordHash),
		Name:         "Carol",
		PartnerCode:  "CAROL1",
	}

	db.Where("email = ?", alice.Email).FirstOrCreate(&alice)
	db.Where("email = ?", bob.Email).FirstOrCreate(&bob)
	db.Where("email = ?", carol.Email).FirstOrCreate(&carol)

	alice.PartnerID = &bob.ID
	bob.PartnerID = &alice.ID
	db.Save(&alice)
	db.Save(&bob)

	db.Where("user_id IN (?)", []uint{alice.ID, bob.ID, carol.ID}).Delete(&models.CycleDay{})

	seedCycleDataForUser(db, alice.ID, time.Date(2026, 1, 5, 0, 0, 0, 0, time.UTC), 6, 5, 28)
	seedCycleDataForUser(db, carol.ID, time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC), 4, 4, 30)

	seedIntercourseDays(db, alice.ID)

	fmt.Println("seed completed successfully")
	fmt.Println()
	fmt.Println("Demo accounts (password: password123):")
	fmt.Printf("  Alice (has partner Bob): %s\n", alice.Email)
	fmt.Printf("  Bob (partner of Alice):  %s\n", bob.Email)
	fmt.Printf("  Carol (no partner):      %s\n", carol.Email)
	fmt.Println()
	fmt.Printf("Alice's partner code: %s\n", alice.PartnerCode)
	fmt.Printf("Bob's partner code:   %s\n", bob.PartnerCode)
	fmt.Printf("Carol's partner code: %s\n", carol.PartnerCode)
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
