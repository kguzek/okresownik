package services

import (
	"math"
	"time"

	"okresownik/internal/models"
)

type PredictionService struct{}

func NewPredictionService() *PredictionService {
	return &PredictionService{}
}

func CalculatePrediction(periodDays []models.CycleDay) (*models.Prediction, error) {
	periodStarts := extractPeriodStarts(periodDays)

	if len(periodStarts) < 2 {
		return minimalPrediction(periodDays), nil
	}

	cycleLengths := calculateCycleLengths(periodStarts)
	avgCycleLength := mean(cycleLengths)
	avgCycleStdDev := stdDev(cycleLengths, avgCycleLength)

	periodDurations := calculatePeriodDurations(periodDays, periodStarts)
	avgPeriodDuration := mean(periodDurations)

	lastPeriodStart := periodStarts[len(periodStarts)-1]
	today := time.Now().Truncate(24 * time.Hour)
	cycleDay := int(today.Sub(lastPeriodStart).Hours()/24) + 1

	nextPeriodStart := lastPeriodStart.AddDate(0, 0, int(math.Round(avgCycleLength)))

	ovulationDate := nextPeriodStart.AddDate(0, 0, -14)

	fertileWindowStart := ovulationDate.AddDate(0, 0, -5)
	fertileWindowEnd := ovulationDate

	confidence := determineConfidence(len(periodStarts), avgCycleStdDev)

	nextPeriodEnd := nextPeriodStart.AddDate(0, 0, int(math.Round(avgPeriodDuration)))

	return &models.Prediction{
		NextPeriodStart:       nextPeriodStart,
		NextPeriodEnd:         nextPeriodEnd,
		OvulationDate:         ovulationDate,
		FertileWindowStart:    fertileWindowStart,
		FertileWindowEnd:      fertileWindowEnd,
		AverageCycleLength:    avgCycleLength,
		AveragePeriodDuration: avgPeriodDuration,
		CycleDay:              cycleDay,
		Confidence:            confidence,
	}, nil
}

func extractPeriodStarts(days []models.CycleDay) []time.Time {
	if len(days) == 0 {
		return nil
	}

	var starts []time.Time
	inPeriod := false

	for _, day := range days {
		if day.IsPeriod && !inPeriod {
			starts = append(starts, day.Date)
			inPeriod = true
		} else if !day.IsPeriod {
			inPeriod = false
		}
	}

	return starts
}

func calculateCycleLengths(starts []time.Time) []float64 {
	if len(starts) < 2 {
		return nil
	}

	lengths := make([]float64, 0, len(starts)-1)
	for i := 1; i < len(starts); i++ {
		days := starts[i].Sub(starts[i-1]).Hours() / 24
		if days >= 18 && days <= 100 {
			lengths = append(lengths, days)
		}
	}

	return lengths
}

func calculatePeriodDurations(days []models.CycleDay, starts []time.Time) []float64 {
	if len(starts) == 0 {
		return nil
	}

	durations := make([]float64, 0, len(starts))

	for _, start := range starts {
		duration := 0.0
		for _, day := range days {
			if day.IsPeriod && !day.Date.Before(start) {
				diff := day.Date.Sub(start).Hours() / 24
				if diff >= 0 && diff <= 14 {
					duration = math.Max(duration, diff+1)
				}
			}
		}
		if duration > 0 {
			durations = append(durations, duration)
		}
	}

	return durations
}

func mean(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}
	sum := 0.0
	for _, v := range values {
		sum += v
	}
	return sum / float64(len(values))
}

func stdDev(values []float64, meanVal float64) float64 {
	if len(values) < 2 {
		return 0
	}
	sumSq := 0.0
	for _, v := range values {
		diff := v - meanVal
		sumSq += diff * diff
	}
	return math.Sqrt(sumSq / float64(len(values)))
}

func determineConfidence(numCycles int, stdDev float64) string {
	if numCycles < 2 {
		return "very_low"
	}
	if numCycles < 3 {
		return "low"
	}
	if stdDev <= 2 {
		return "high"
	}
	if stdDev <= 5 {
		return "medium"
	}
	return "low"
}

func minimalPrediction(periodDays []models.CycleDay) *models.Prediction {
	var lastPeriodStart time.Time
	var periodDuration float64 = 5

	if len(periodDays) > 0 {
		lastPeriodStart = periodDays[0].Date
		count := 0.0
		for _, d := range periodDays {
			if d.IsPeriod {
				count++
			}
		}
		if count > 0 {
			periodDuration = count
		}
	} else {
		lastPeriodStart = time.Now().Truncate(24 * time.Hour)
	}

	today := time.Now().Truncate(24 * time.Hour)
	cycleDay := int(today.Sub(lastPeriodStart).Hours()/24) + 1
	avgCycleLen := 28.0

	nextPeriodStart := lastPeriodStart.AddDate(0, 0, int(avgCycleLen))
	ovulationDate := nextPeriodStart.AddDate(0, 0, -14)
	fertileWindowStart := ovulationDate.AddDate(0, 0, -5)
	fertileWindowEnd := ovulationDate
	nextPeriodEnd := nextPeriodStart.AddDate(0, 0, int(periodDuration))

	return &models.Prediction{
		NextPeriodStart:       nextPeriodStart,
		NextPeriodEnd:         nextPeriodEnd,
		OvulationDate:         ovulationDate,
		FertileWindowStart:    fertileWindowStart,
		FertileWindowEnd:      fertileWindowEnd,
		AverageCycleLength:    avgCycleLen,
		AveragePeriodDuration: periodDuration,
		CycleDay:              cycleDay,
		Confidence:            "very_low",
	}
}
