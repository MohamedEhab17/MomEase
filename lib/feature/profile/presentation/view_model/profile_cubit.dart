import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/profile/dummy/profile_dummy_data.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void loadProfile(BuildContext context) async {
    emit(ProfileLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      final profile = ProfileDummyData.getDummyProfile(context);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: "Failed to load profile data"));
    }
  }
}
