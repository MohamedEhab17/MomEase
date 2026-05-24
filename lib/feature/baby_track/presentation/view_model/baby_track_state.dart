part of 'baby_track_cubit.dart';

abstract class BabyTrackState {}

class BabyTrackInitial extends BabyTrackState {}

// ---- Feeding States ----
class FeedingTimerState extends BabyTrackState {
  final int elapsedSeconds;
  final bool isRunning;
  FeedingTimerState({required this.elapsedSeconds, required this.isRunning});
}

class FeedingSessionSaved extends BabyTrackState {}

class FeedingRecordLoading extends BabyTrackState {}
class FeedingRecordSaved extends BabyTrackState {}
class FeedingRecordError extends BabyTrackState {
  final String errorMessage;
  FeedingRecordError({required this.errorMessage});
}

// ---- Sleep States ----
class SleepRecordLoading extends BabyTrackState {}
class SleepRecordSaved extends BabyTrackState {}
class SleepRecordError extends BabyTrackState {
  final String errorMessage;
  SleepRecordError({required this.errorMessage});
}

// ---- Vaccine States ----
class VaccineTabState extends BabyTrackState {
  final int tabIndex; // 0 = Baby's Log, 1 = Official Schedule
  VaccineTabState({required this.tabIndex});
}

// ---- Main Tab States ----
class MainTabChanged extends BabyTrackState {
  final int tabIndex; // 0=Feeding, 1=Sleep, 2=Vaccine
  MainTabChanged({required this.tabIndex});
}
