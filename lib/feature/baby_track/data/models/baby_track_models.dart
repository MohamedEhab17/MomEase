import 'package:flutter/material.dart';

// Enums

enum FeedingType { breastfeeding, formulaFeeding, solidfood }

enum VaccineStatus { completed, upcoming }

// Models

class FeedingSession {
  final String id;
  final FeedingType type;
  final DateTime date;
  final int durationSeconds;
  final String notes;

  const FeedingSession({
    required this.id,
    required this.type,
    required this.date,
    required this.durationSeconds,
    this.notes = '',
  });

  String get feedingTypeLabel {
    switch (type) {
      case FeedingType.breastfeeding:
        return 'Breastfeeding';
      case FeedingType.formulaFeeding:
        return 'Formula Feeding';
      case FeedingType.solidfood:
        return 'Solid Food';
    }
  }

  String get formattedDuration {
    final m = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  FeedingSession copyWith({
    String? id,
    FeedingType? type,
    DateTime? date,
    int? durationSeconds,
    String? notes,
  }) {
    return FeedingSession(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
    );
  }
}

// ─────────────────────────────────────────────

class SleepSession {
  final String id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String notes;

  const SleepSession({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.notes = '',
  });

  double get durationHours {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final diff = endMinutes - startMinutes;
    return diff > 0 ? diff / 60.0 : (diff + 1440) / 60.0;
  }

  String get formattedStartTime {
    final h = startTime.hourOfPeriod == 0 ? 12 : startTime.hourOfPeriod;
    final m = startTime.minute.toString().padLeft(2, '0');
    final period = startTime.period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $period';
  }

  String get formattedEndTime {
    final h = endTime.hourOfPeriod == 0 ? 12 : endTime.hourOfPeriod;
    final m = endTime.minute.toString().padLeft(2, '0');
    final period = endTime.period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $period';
  }
}

// ─────────────────────────────────────────────

class VaccineRecord {
  final String id;
  final String name;
  final String doseInfo;
  final DateTime date;
  final VaccineStatus status;

  const VaccineRecord({
    required this.id,
    required this.name,
    required this.doseInfo,
    required this.date,
    required this.status,
  });
}
