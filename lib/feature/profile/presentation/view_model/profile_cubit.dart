import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/profile/dummy/profile_dummy_data.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_state.dart';

@injectable
class ProfileCubit extends SafeCubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void loadProfile() {
    safeEmit(ProfileLoading());
    
    // Using CancelableOperation from SafeCubit
    final operation = cancelableOperation(Future.delayed(const Duration(milliseconds: 600)));
    
    operation.value.then((_) {
      try {
        final profile = ProfileDummyData.getDummyProfile();
        safeEmit(ProfileLoaded(profile: profile));
      } catch (e) {
        safeEmit(const ProfileError(message: "Failed to load profile data"));
      }
    });
  }
}
