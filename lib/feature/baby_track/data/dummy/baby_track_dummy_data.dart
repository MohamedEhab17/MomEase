import 'package:flutter/material.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

// ─────────────────────────────────────────────
// Dummy Feeding Sessions
// ─────────────────────────────────────────────

final List<FeedingSession> dummyFeedingSessions = [
  FeedingSession(
    id: 'f1',
    type: FeedingType.breastfeeding,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    durationSeconds: 840,
    notes: 'Baby was calm and fed well.',
  ),
  FeedingSession(
    id: 'f2',
    type: FeedingType.formulaFeeding,
    date: DateTime.now().subtract(const Duration(hours: 7)),
    durationSeconds: 600,
    notes: '',
  ),
  FeedingSession(
    id: 'f3',
    type: FeedingType.breastfeeding,
    date: DateTime.now().subtract(const Duration(hours: 11)),
    durationSeconds: 720,
    notes: 'Baby was a bit fussy at start.',
  ),
];

// ─────────────────────────────────────────────
// Dummy Sleep Sessions
// ─────────────────────────────────────────────

final List<SleepSession> dummySleepSessions = [
  SleepSession(
    id: 's1',
    date: DateTime.now().subtract(const Duration(days: 1)),
    startTime: const TimeOfDay(hour: 21, minute: 0),
    endTime: const TimeOfDay(hour: 4, minute: 30),
    notes: 'Slept peacefully through the night.',
  ),
  SleepSession(
    id: 's2',
    date: DateTime.now().subtract(const Duration(days: 2)),
    startTime: const TimeOfDay(hour: 20, minute: 30),
    endTime: const TimeOfDay(hour: 4, minute: 0),
    notes: '',
  ),
];

// ─────────────────────────────────────────────
// Dummy Vaccine Records
// ─────────────────────────────────────────────

final List<VaccineRecord> dummyVaccineRecords = [
  VaccineRecord(
    id: 'v1',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 8, 12),
    status: VaccineStatus.completed,
  ),
  VaccineRecord(
    id: 'v2',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 8, 12),
    status: VaccineStatus.completed,
  ),
  VaccineRecord(
    id: 'v3',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 8, 12),
    status: VaccineStatus.completed,
  ),
  VaccineRecord(
    id: 'v4',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
  VaccineRecord(
    id: 'v5',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
  VaccineRecord(
    id: 'v6',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
];

final List<VaccineRecord> dummyOfficialScheduleRecords = [
  VaccineRecord(
    id: 'o1',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 8, 12),
    status: VaccineStatus.completed,
  ),
  VaccineRecord(
    id: 'o2',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 8, 12),
    status: VaccineStatus.completed,
  ),
  VaccineRecord(
    id: 'o3',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
  VaccineRecord(
    id: 'o4',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
  VaccineRecord(
    id: 'o5',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
  VaccineRecord(
    id: 'o6',
    name: 'Hepatitis B (HepB)',
    doseInfo: '2 mo / of 3 • Aug 12 2025',
    date: DateTime(2025, 10, 15),
    status: VaccineStatus.upcoming,
  ),
];

// ─────────────────────────────────────────────
// Insights Data
// ─────────────────────────────────────────────

/// Last 7 days feeding frequency (number of sessions per day)
final List<double> feedingFrequencyData = [3, 4, 3, 5, 4, 6, 4];

/// Last 24h sleep duration chart points (normalised 0–1)
final List<double> sleepDurationPoints = [
  0.4,
  0.5,
  0.55,
  0.6,
  0.7,
  0.65,
  0.8,
  0.75,
  0.7,
  0.6,
];

/// Mother mood trend points (normalised 0–1)
final List<double> moodTrendPoints = [
  0.6,
  0.55,
  0.65,
  0.7,
  0.6,
  0.65,
  0.75,
  0.7,
  0.8,
  0.75,
];
