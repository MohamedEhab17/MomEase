import 'dart:async';

import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

import 'package:new_mama/core/base/safe_cubit.dart';

part 'baby_track_state.dart';

class BabyTrackCubit extends SafeCubit<BabyTrackState> {
  BabyTrackCubit() : super(BabyTrackInitial());

  // ─────── Main tab ───────
  int mainTabIndex = 0;

  void switchMainTab(int index) {
    mainTabIndex = index;
    safeEmit(MainTabChanged(tabIndex: index));
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
      safeEmit(
        FeedingTimerState(
          elapsedSeconds: _elapsedSeconds,
          isRunning: _isRunning,
        ),
      );
    });
    safeEmit(
      FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: _isRunning),
    );
  }

  void stopFeedingTimer() {
    _feedingTimer?.cancel();
    _feedingTimer = null;
    _isRunning = false;
    safeEmit(
      FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: _isRunning),
    );
  }

  void resetFeedingTimer() {
    stopFeedingTimer();
    _elapsedSeconds = 0;
    safeEmit(FeedingTimerState(elapsedSeconds: _elapsedSeconds, isRunning: false));
  }

  void saveFeedingSession(FeedingSession session) {
    resetFeedingTimer();
    safeEmit(FeedingSessionSaved());
  }

  // ─────── Sleep ───────
  void saveSleepRecord(SleepSession session) {
    safeEmit(SleepRecordSaved());
  }

  // ─────── Vaccine Tab ───────
  int vaccineTabIndex = 0;

  void switchVaccineTab(int index) {
    vaccineTabIndex = index;
    safeEmit(VaccineTabState(tabIndex: index));
  }

  @override
  Future<void> close() {
    _feedingTimer?.cancel();
    return super.close();
  }
}
