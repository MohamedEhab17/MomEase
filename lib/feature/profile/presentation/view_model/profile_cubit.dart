import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../domain/entity/mother_profile.dart';
import '../../domain/usecase/profile_usecases.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends SafeCubit<ProfileState> {
  final GetMotherProfileUseCase _getProfileUseCase;
  final UpdateMotherProfileUseCase _updateProfileUseCase;
  final UploadProfilePhotoUseCase _uploadPhotoUseCase;
  final DeleteProfilePhotoUseCase _deletePhotoUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._uploadPhotoUseCase,
    this._deletePhotoUseCase,
  ) : super(const ProfileState());

  /// Wipes all user data immediately (call on logout before navigating away).
  void clearState() => safeEmit(const ProfileState());

  Future<void> loadProfile() async {
    safeEmit(const ProfileState(status: ProfileStatus.loading));
    
    final result = await _getProfileUseCase();
    
    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (profile) => safeEmit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      )),
    );
  }

  Future<void> updateProfile({
    required bool isFirstTimeMother,
    required int numberOfChildren,
    String? mentalHealthStatus,
    String? healthStatus,
  }) async {
    if (state.profile == null) return;

    safeEmit(state.copyWith(status: ProfileStatus.updating, clearError: true));

    final updatedEntity = state.profile!.copyWith(
      isFirstTimeMother: isFirstTimeMother,
      numberOfChildren: numberOfChildren,
      mentalHealthStatus: mentalHealthStatus,
      healthStatus: healthStatus,
    );

    final result = await _updateProfileUseCase(updatedEntity);

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: ProfileStatus.loaded,
        errorMessage: failure.message,
      )),
      (updatedProfile) => safeEmit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
        clearError: true,
      )),
    );
  }

  Future<void> uploadPhoto(String filePath) async {
    debugPrint('[ProfileCubit] uploadPhoto started for path: $filePath');
    safeEmit(state.copyWith(status: ProfileStatus.uploadingPhoto, clearError: true));

    final result = await _uploadPhotoUseCase(filePath);

    result.fold(
      (failure) {
        debugPrint('[ProfileCubit] uploadPhoto failed: ${failure.message}');
        safeEmit(state.copyWith(
          status: ProfileStatus.loaded,
          errorMessage: failure.message,
        ));
      },
      (photoUrl) {
        debugPrint('[ProfileCubit] uploadPhoto succeeded, photoUrl: $photoUrl');
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(profilePictureUrl: photoUrl);
          safeEmit(state.copyWith(
            status: ProfileStatus.loaded,
            profile: updatedProfile,
            clearError: true,
          ));
        }
      },
    );
  }

  Future<void> deletePhoto() async {
    debugPrint('[ProfileCubit] deletePhoto started');
    safeEmit(state.copyWith(status: ProfileStatus.deletingPhoto, clearError: true));

    final result = await _deletePhotoUseCase();

    result.fold(
      (failure) {
        debugPrint('[ProfileCubit] deletePhoto failed: ${failure.message}');
        safeEmit(state.copyWith(
          status: ProfileStatus.loaded,
          errorMessage: failure.message,
        ));
      },
      (_) {
        debugPrint('[ProfileCubit] deletePhoto succeeded');
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(profilePictureUrl: null, clearPhoto: true);
          safeEmit(state.copyWith(
            status: ProfileStatus.loaded,
            profile: updatedProfile,
            clearError: true,
          ));
        }
      },
    );
  }
}

extension on MotherProfile {
  MotherProfile copyWith({
    bool? isFirstTimeMother,
    int? numberOfChildren,
    String? mentalHealthStatus,
    String? healthStatus,
    String? profilePictureUrl,
    bool clearPhoto = false,
  }) {
    return MotherProfile(
      motherId: motherId,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      isFirstTimeMother: isFirstTimeMother ?? this.isFirstTimeMother,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      mentalHealthStatus: mentalHealthStatus ?? this.mentalHealthStatus,
      healthStatus: healthStatus ?? this.healthStatus,
      profilePictureUrl: clearPhoto ? null : (profilePictureUrl ?? this.profilePictureUrl),
      createdAt: createdAt,
    );
  }
}
