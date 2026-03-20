import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

part 'baby_track_state.dart';

class BabyTrackCubit extends Cubit<BabyTrackState> {
  BabyTrackCubit() : super(BabyTrackInitial());

  // ─────── Main tab ───────
  int mainTabIndex = 0;

  void switchMainTab(int index) {
    mainTabIndex = index;
    emit(MainTabChanged(tabIndex: index));
  }

  // ─────── Feeding Timer ───────
  Timer? _feedingTimer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;

  void startFeedingTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _feedingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      emit(
        FeedingTimerState(
          elapsedSeconds: _elapsedSeconds,
          isRunning: _isRunning,
        ),
      );
    });
    emit(
      FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: _isRunning),
    );
  }

  void stopFeedingTimer() {
    _feedingTimer?.cancel();
    _feedingTimer = null;
    _isRunning = false;
    emit(
      FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: _isRunning),
    );
  }

  void resetFeedingTimer() {
    stopFeedingTimer();
    _elapsedSeconds = 0;
    emit(FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: false));
  }

  void saveFeedingSession(FeedingSession session) {
    resetFeedingTimer();
    emit(FeedingSessionSaved());
  }

  // ─────── Sleep ───────
  void saveSleepRecord(SleepSession session) {
    emit(SleepRecordSaved());
  }

  // ─────── Vaccine Tab ───────
  int vaccineTabIndex = 0;

  void switchVaccineTab(int index) {
    vaccineTabIndex = index;
    emit(VaccineTabState(tabIndex: index));
  }

  @override
  Future<void> close() {
    _feedingTimer?.cancel();
    return super.close();
  }
}
