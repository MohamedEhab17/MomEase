import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_local_datasource_contract.dart';
import 'package:new_mama/feature/app_section/domain/usecases/logout_usecase.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/logout_cubit/logout_state.dart';

@injectable
class LogoutCubit extends SafeCubit<LogoutState> {
  final LogoutUseCase logoutUseCase;
  final AppSectionLocalDatasourceContract local;
  

  LogoutCubit(this.logoutUseCase, this.local)
      : super(LogoutInitial());

 Future<void> logout() async {
  safeEmit(LogoutLoading());

  final refreshToken = await local.getRefreshToken();

  if (refreshToken == null) {
    safeEmit(LogoutFailure("No refresh token found"));
    return;
  }

  final result = await logoutUseCase(refreshToken.trim());

  result.fold(
    (failure) => safeEmit(LogoutFailure(failure.message)),
    (_) async {
      await local.clearTokens();    
      safeEmit(LogoutSuccess());
    },
  );
}
}