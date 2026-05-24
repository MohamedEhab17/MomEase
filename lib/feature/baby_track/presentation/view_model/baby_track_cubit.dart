import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/add_sleep_record_usecase.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/add_feeding_record_usecase.dart';
import 'package:new_mama/core/base/safe_cubit.dart';

part 'baby_track_state.dart';

@injectable
class BabyTrackCubit extends SafeCubit<BabyTrackState> {
  final AddSleepRecordUseCase _addSleepRecordUseCase;
  final AddFeedingRecordUseCase _addFeedingRecordUseCase;

  BabyTrackCubit(
    this._addSleepRecordUseCase,
    this._addFeedingRecordUseCase,
  ) : super(BabyTrackInitial());

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
  Future<void> saveSleepRecord({
    required int childId,
    required AddSleepRecordRequestModel request,
  }) async {
    safeEmit(SleepRecordLoading());
    final result = await _addSleepRecordUseCase(
      childId: childId,
      request: request,
    );
    result.fold(
      (failure) => safeEmit(SleepRecordError(errorMessage: failure.message)),
      (record) => safeEmit(SleepRecordSaved()),
    );
  }

  // ─────── Feeding ───────
  Future<void> saveFeedingRecord({
    required int childId,
    required AddFeedingRecordRequestModel request,
  }) async {
    safeEmit(FeedingRecordLoading());
    final result = await _addFeedingRecordUseCase(
      childId: childId,
      request: request,
    );
    result.fold(
      (failure) => safeEmit(FeedingRecordError(errorMessage: failure.message)),
      (record) => safeEmit(FeedingRecordSaved()),
    );
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
