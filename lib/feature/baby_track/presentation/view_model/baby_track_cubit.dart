import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/add_sleep_record_usecase.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/add_feeding_record_usecase.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_feeding_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/delete_feeding_record_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_sleep_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/delete_sleep_record_usecase.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/add_growth_record_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_growth_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/delete_growth_record_usecase.dart';

part 'baby_track_state.dart';

@injectable
class BabyTrackCubit extends SafeCubit<BabyTrackState> {
  final AddSleepRecordUseCase _addSleepRecordUseCase;
  final AddFeedingRecordUseCase _addFeedingRecordUseCase;
  final GetFeedingRecordsUseCase _getFeedingRecordsUseCase;
  final DeleteFeedingRecordUseCase _deleteFeedingRecordUseCase;
  final GetSleepRecordsUseCase _getSleepRecordsUseCase;
  final DeleteSleepRecordUseCase _deleteSleepRecordUseCase;
  final AddGrowthRecordUseCase _addGrowthRecordUseCase;
  final GetGrowthRecordsUseCase _getGrowthRecordsUseCase;
  final DeleteGrowthRecordUseCase _deleteGrowthRecordUseCase;

  BabyTrackCubit(
    this._addSleepRecordUseCase,
    this._addFeedingRecordUseCase,
    this._getFeedingRecordsUseCase,
    this._deleteFeedingRecordUseCase,
    this._getSleepRecordsUseCase,
    this._deleteSleepRecordUseCase,
    this._addGrowthRecordUseCase,
    this._getGrowthRecordsUseCase,
    this._deleteGrowthRecordUseCase,
  ) : super(BabyTrackInitial());

  // ─────── Records lists & Deleting IDs ───────
  List<FeedingRecordEntity> feedingRecords = [];
  List<SleepRecordEntity> sleepRecords = [];
  List<GrowthRecordEntity> growthRecords = [];
  int? deletingFeedingRecordId;
  int? deletingSleepRecordId;
  int? deletingGrowthRecordId;

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
      (record) {
        safeEmit(SleepRecordSaved());
        fetchSleepRecords(childId);
      },
    );
  }

  Future<void> fetchSleepRecords(int childId) async {
    safeEmit(SleepRecordsLoading());
    final result = await _getSleepRecordsUseCase(childId);
    result.fold(
      (failure) => safeEmit(SleepRecordsError(errorMessage: failure.message)),
      (records) {
        sleepRecords = records;
        safeEmit(SleepRecordsLoaded(records: records));
      },
    );
  }

  Future<void> deleteSleepRecord({required int childId, required int recordId}) async {
    deletingSleepRecordId = recordId;
    safeEmit(SleepRecordDeleting(recordId: recordId));
    final result = await _deleteSleepRecordUseCase(childId: childId, recordId: recordId);
    result.fold(
      (failure) {
        deletingSleepRecordId = null;
        safeEmit(SleepRecordsError(errorMessage: failure.message));
      },
      (_) {
        deletingSleepRecordId = null;
        sleepRecords.removeWhere((r) => r.recordId == recordId);
        safeEmit(SleepRecordDeleted());
        safeEmit(SleepRecordsLoaded(records: sleepRecords));
      },
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
      (record) {
        safeEmit(FeedingRecordSaved());
        fetchFeedingRecords(childId);
      },
    );
  }

  Future<void> fetchFeedingRecords(int childId) async {
    safeEmit(FeedingRecordsLoading());
    final result = await _getFeedingRecordsUseCase(childId);
    result.fold(
      (failure) => safeEmit(FeedingRecordsError(errorMessage: failure.message)),
      (records) {
        feedingRecords = records;
        safeEmit(FeedingRecordsLoaded(records: records));
      },
    );
  }

  Future<void> deleteFeedingRecord({required int childId, required int recordId}) async {
    deletingFeedingRecordId = recordId;
    safeEmit(FeedingRecordDeleting(recordId: recordId));
    final result = await _deleteFeedingRecordUseCase(childId: childId, recordId: recordId);
    result.fold(
      (failure) {
        deletingFeedingRecordId = null;
        safeEmit(FeedingRecordsError(errorMessage: failure.message));
      },
      (_) {
        deletingFeedingRecordId = null;
        feedingRecords.removeWhere((r) => r.recordId == recordId);
        safeEmit(FeedingRecordDeleted());
        safeEmit(FeedingRecordsLoaded(records: feedingRecords));
      },
    );
  }

  // ─────── Growth ───────
  Future<void> saveGrowthRecord({
    required int childId,
    required AddGrowthRecordRequestModel request,
  }) async {
    safeEmit(GrowthRecordLoading());
    final result = await _addGrowthRecordUseCase(
      childId: childId,
      request: request,
    );
    result.fold(
      (failure) => safeEmit(GrowthRecordError(errorMessage: failure.message)),
      (record) {
        safeEmit(GrowthRecordSaved());
        fetchGrowthRecords(childId);
      },
    );
  }

  Future<void> fetchGrowthRecords(int childId) async {
    safeEmit(GrowthRecordsLoading());
    final result = await _getGrowthRecordsUseCase(childId);
    result.fold(
      (failure) => safeEmit(GrowthRecordsError(errorMessage: failure.message)),
      (records) {
        growthRecords = records;
        safeEmit(GrowthRecordsLoaded(records: records));
      },
    );
  }

  Future<void> deleteGrowthRecord({required int childId, required int recordId}) async {
    deletingGrowthRecordId = recordId;
    safeEmit(GrowthRecordDeleting(recordId: recordId));
    final result = await _deleteGrowthRecordUseCase(childId: childId, recordId: recordId);
    result.fold(
      (failure) {
        deletingGrowthRecordId = null;
        safeEmit(GrowthRecordsError(errorMessage: failure.message));
      },
      (_) {
        deletingGrowthRecordId = null;
        growthRecords.removeWhere((r) => r.growthId == recordId);
        safeEmit(GrowthRecordDeleted());
        safeEmit(GrowthRecordsLoaded(records: growthRecords));
      },
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
