import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/services/fcm_service.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_local_datasource_contract.dart';
import 'package:new_mama/feature/app_section/domain/usecases/logout_usecase.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/logout_cubit/logout_state.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart'
    as old;
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/notifications/domain/usecases/device_token_usecases.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_cubit.dart' as mother;

@injectable
class LogoutCubit extends SafeCubit<LogoutState> {
  final LogoutUseCase logoutUseCase;
  final AppSectionLocalDatasourceContract local;
  final RemoveDeviceTokenUseCase removeDeviceTokenUseCase;

  LogoutCubit(this.logoutUseCase, this.local, this.removeDeviceTokenUseCase)
      : super(LogoutInitial());

  Future<void> logout() async {
    safeEmit(LogoutLoading());

    // 1. Remove FCM token from backend silently before logout.
    final fcmToken = await FcmService.getToken();
    if (fcmToken != null) {
      await removeDeviceTokenUseCase(fcmToken);
    }

    // 2. Get refresh token for server-side logout.
    final refreshToken = await local.getRefreshToken();
    if (refreshToken == null) {
      safeEmit(LogoutFailure("No refresh token found"));
      return;
    }

    // 3. Call backend logout endpoint.
    final result = await logoutUseCase(refreshToken.trim());

    result.fold(
      (failure) => safeEmit(LogoutFailure(failure.message)),
      (_) async {
        // 4. Clear tokens from secure storage.
        await local.clearTokens();

        // 5. Wipe all in-memory user data from singletons BEFORE navigating
        //    to login. This guarantees that no stale profile, children, or
        //    active-child data leaks into the next user's session.
        getIt<mother.ProfileCubit>().clearState();
        getIt<old.ProfileCubit>().clearState();
        getIt<ChildrenCubit>().clearState();
        getIt<ActiveChildCubit>().clearActiveChild();

        safeEmit(LogoutSuccess());
      },
    );
  }
}