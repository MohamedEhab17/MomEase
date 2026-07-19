import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/app_section/domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase _getProfileUsecase;

  ProfileCubit(this._getProfileUsecase) : super(ProfileInitial());

  /// Wipes all user data immediately (call on logout before navigating away).
  void clearState() => emit(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final result = await _getProfileUsecase();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
