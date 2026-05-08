// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:record/record.dart' as _i1039;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../feature/app_section/data/datasources/app_section_local_datasource_contract.dart'
    as _i435;
import '../../feature/app_section/data/datasources/app_section_local_datasource_impl.dart'
    as _i95;
import '../../feature/app_section/data/datasources/app_section_remote_datasource_contract.dart'
    as _i663;
import '../../feature/app_section/data/datasources/app_section_remote_datasource_impl.dart'
    as _i250;
import '../../feature/app_section/data/repositories/app_section_repository_impl.dart'
    as _i67;
import '../../feature/app_section/domain/repositories/app_section_repository_contract.dart'
    as _i417;
import '../../feature/app_section/domain/usecases/change_password_usecase.dart'
    as _i139;
import '../../feature/app_section/domain/usecases/get_profile_usecase.dart'
    as _i319;
import '../../feature/app_section/domain/usecases/logout_usecase.dart' as _i480;
import '../../feature/app_section/domain/usecases/update_profile_usecase.dart'
    as _i84;
import '../../feature/app_section/presentation/view_model/logout_cubit/logout_cubit.dart'
    as _i434;
import '../../feature/app_section/presentation/view_model/manage_profile_cubit/manage_profile_cubit.dart'
    as _i650;
import '../../feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart'
    as _i580;
import '../../feature/articles/data/datasource/article_local_datasource.dart'
    as _i921;
import '../../feature/articles/data/datasource/article_remote_datasource_contract.dart'
    as _i159;
import '../../feature/articles/data/datasource/article_remote_datasource_impl.dart'
    as _i867;
import '../../feature/articles/data/repository/article_repository_impl.dart'
    as _i625;
import '../../feature/articles/domain/repositories/articles_repository.dart'
    as _i18;
import '../../feature/articles/domain/usecases/article_usecases.dart' as _i875;
import '../../feature/articles/domain/usecases/get_articles_category_usecase.dart'
    as _i537;
import '../../feature/articles/domain/usecases/search_articles_usecase.dart'
    as _i695;
import '../../feature/articles/domain/usecases/search_history_usecases.dart'
    as _i361;
import '../../feature/articles/domain/usecases/watch_article_save_status_usecase.dart'
    as _i839;
import '../../feature/articles/presentation/view_model/article_detail/article_detail_cubit.dart'
    as _i187;
import '../../feature/articles/presentation/view_model/categories_cubit/category_cubit.dart'
    as _i964;
import '../../feature/articles/presentation/view_model/category_articles/category_articles_cubit.dart'
    as _i612;
import '../../feature/articles/presentation/view_model/saved_articles/saved_articles_cubit.dart'
    as _i973;
import '../../feature/articles/presentation/view_model/search_articles/search_articles_cubit.dart'
    as _i982;
import '../../feature/auth/data/datasources/auth_local_data_source_contract.dart'
    as _i622;
import '../../feature/auth/data/datasources/auth_local_data_source_impl.dart'
    as _i557;
import '../../feature/auth/data/datasources/auth_remote_data_source_contract.dart'
    as _i961;
import '../../feature/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i283;
import '../../feature/auth/data/repositories/auth_repository_impl.dart'
    as _i263;
import '../../feature/auth/domain/repositories/auth_repository.dart' as _i488;
import '../../feature/auth/domain/usecases/biometric_login_use_case.dart'
    as _i989;
import '../../feature/auth/domain/usecases/change_password_use_case.dart'
    as _i849;
import '../../feature/auth/domain/usecases/forgot_password_use_case.dart'
    as _i385;
import '../../feature/auth/domain/usecases/google_login_use_case.dart' as _i364;
import '../../feature/auth/domain/usecases/login_use_case.dart' as _i398;
import '../../feature/auth/domain/usecases/register_use_case.dart' as _i584;
import '../../feature/auth/domain/usecases/resend_otp_use_case.dart' as _i19;
import '../../feature/auth/domain/usecases/reset_password_use_case.dart'
    as _i420;
import '../../feature/auth/domain/usecases/revoke_token_use_case.dart' as _i804;
import '../../feature/auth/domain/usecases/verify_email_use_case.dart' as _i352;
import '../../feature/auth/presentation/cubit/auth_cubit.dart' as _i47;
import '../../feature/baby_cry/data/data_source/audio_local_data_source.dart'
    as _i96;
import '../../feature/baby_cry/data/data_source/audio_local_data_source_impl.dart'
    as _i881;
import '../../feature/baby_cry/data/repository/audio_repository.dart' as _i0;
import '../../feature/baby_cry/data/repository/audio_repository_impl.dart'
    as _i636;
import '../../feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart'
    as _i589;
import '../../feature/children/data/datasources/children_remote_data_source.dart'
    as _i1010;
import '../../feature/children/data/datasources/children_remote_data_source_impl.dart'
    as _i676;
import '../../feature/children/data/repositories/children_repository_impl.dart'
    as _i995;
import '../../feature/children/domain/repositories/children_repository.dart'
    as _i889;
import '../../feature/children/domain/usecases/create_child_use_case.dart'
    as _i292;
import '../../feature/children/domain/usecases/delete_child_use_case.dart'
    as _i103;
import '../../feature/children/domain/usecases/get_child_use_case.dart'
    as _i698;
import '../../feature/children/domain/usecases/get_children_use_case.dart'
    as _i1057;
import '../../feature/children/domain/usecases/manage_child_photo_use_case.dart'
    as _i157;
import '../../feature/children/domain/usecases/update_child_use_case.dart'
    as _i178;
import '../../feature/children/presentation/cubit/active_child_cubit.dart'
    as _i449;
import '../../feature/children/presentation/cubit/children_cubit.dart' as _i555;
import '../../feature/community/data/datasource/community_local_datasource.dart'
    as _i97;
import '../../feature/community/data/repository/community_repository.dart'
    as _i963;
import '../../feature/community/data/repository/community_repository_impl.dart'
    as _i272;
import '../../feature/community/domain/usecases/community_usecases.dart'
    as _i1038;
import '../../feature/community/presentation/view_model/community_cubit.dart'
    as _i1026;
import '../../feature/depression/data/datasources/assessment_remote_data_source_contract.dart'
    as _i766;
import '../../feature/depression/data/datasources/assessment_remote_data_source_impl.dart'
    as _i730;
import '../../feature/depression/data/repositories/assessments_repository_impl.dart'
    as _i501;
import '../../feature/depression/domain/repositories/assessment_repository.dart'
    as _i121;
import '../../feature/depression/domain/usecase/get_assessment_by_id_usecase.dart'
    as _i812;
import '../../feature/depression/domain/usecase/get_assessment_result_usecase.dart'
    as _i156;
import '../../feature/depression/domain/usecase/get_assessments_usecase.dart'
    as _i9;
import '../../feature/depression/domain/usecase/get_options_usecase.dart'
    as _i895;
import '../../feature/depression/domain/usecase/get_question_by_id_usecase.dart'
    as _i552;
import '../../feature/depression/domain/usecase/get_questions_usecase.dart'
    as _i670;
import '../../feature/depression/domain/usecase/submit_assessment_usecase.dart'
    as _i331;
import '../../feature/depression/presentation/view_model/assessment_result_cubit/assessment_result_cubit.dart'
    as _i712;
import '../../feature/depression/presentation/view_model/assessments_cubit/assessments_cubit.dart'
    as _i550;
import '../../feature/depression/presentation/view_model/questions_cubit/questions_cubit.dart'
    as _i458;
import '../../feature/depression/presentation/view_model/submit_cubit/submit_cubit.dart'
    as _i562;
import '../../feature/home/presentation/view_model/home_articles/home_articles_cubit.dart'
    as _i850;
import '../../feature/notifications/data/datasource/notification_local_datasource.dart'
    as _i967;
import '../../feature/notifications/data/repository/notification_repository.dart'
    as _i660;
import '../../feature/notifications/data/repository/notification_repository_impl.dart'
    as _i679;
import '../../feature/notifications/domain/usecases/notification_usecases.dart'
    as _i1042;
import '../../feature/notifications/presentation/view_model/notification_cubit.dart'
    as _i473;
import '../../feature/profile/presentation/view_model/profile_cubit.dart'
    as _i386;
import '../helper/biometric_helper.dart' as _i792;
import '../helper/google_auth_helper.dart' as _i375;
import '../helper/secure_storage_helper.dart' as _i790;
import '../localization/cubit/language_cubit.dart' as _i866;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i386.ProfileCubit>(() => _i386.ProfileCubit());
    gh.lazySingleton<_i1039.AudioRecorder>(() => appModule.audioRecorder);
    gh.lazySingleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i152.LocalAuthentication>(() => appModule.localAuth);
    gh.lazySingleton<_i375.GoogleAuthHelper>(() => _i375.GoogleAuthHelper());
    gh.lazySingleton<_i866.LanguageCubit>(() => _i866.LanguageCubit());
    gh.lazySingleton<_i449.ActiveChildCubit>(() => _i449.ActiveChildCubit());
    gh.lazySingleton<_i557.ApiClient>(
      () => appModule.apiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i961.AuthRemoteDataSource>(
      () => _i283.AuthRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i97.CommunityLocalDataSource>(
      () => _i97.CommunityLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i967.NotificationLocalDataSource>(
      () => _i967.NotificationLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i1010.ChildrenRemoteDataSource>(
      () => _i676.ChildrenRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i921.ArticleLocalDataSource>(
      () => _i921.ArticleLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i660.NotificationRepository>(
      () => _i679.NotificationRepositoryImpl(
        gh<_i967.NotificationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i790.SecureStorageHelper>(
      () => _i790.SecureStorageHelper(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i96.AudioLocalDataSource>(
      () => _i881.AudioLocalDataSourceImpl(gh<_i1039.AudioRecorder>()),
    );
    gh.lazySingleton<_i792.BiometricHelper>(
      () => _i792.BiometricHelper(gh<_i152.LocalAuthentication>()),
    );
    gh.lazySingleton<_i963.CommunityRepository>(
      () => _i272.CommunityRepositoryImpl(gh<_i97.CommunityLocalDataSource>()),
    );
    gh.lazySingleton<_i0.AudioRepository>(
      () => _i636.AudioRepositoryImpl(gh<_i96.AudioLocalDataSource>()),
    );
    gh.lazySingleton<_i435.AppSectionLocalDatasourceContract>(
      () => _i95.AppSectionLocalDatasourceImpl(gh<_i790.SecureStorageHelper>()),
    );
    gh.factory<_i589.SoundRecordingCubit>(
      () => _i589.SoundRecordingCubit(gh<_i0.AudioRepository>()),
    );
    gh.lazySingleton<_i766.AssessmentRemoteDataSourceContract>(
      () => _i730.AssessmentRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i663.AppSectionRemoteDatasourceContract>(
      () => _i250.AppSectionRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i159.ArticleRemoteDataSourceContract>(
      () => _i867.ArticleRemoteDatasourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i121.AssessmentRepository>(
      () => _i501.AssessmentRepositoryImpl(
        gh<_i766.AssessmentRemoteDataSourceContract>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i889.ChildrenRepository>(
      () => _i995.ChildrenRepositoryImpl(
        gh<_i1010.ChildrenRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i622.AuthLocalDataSource>(
      () => _i557.AuthLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
        gh<_i790.SecureStorageHelper>(),
      ),
    );
    gh.factory<_i1042.GetNotificationsUseCase>(
      () => _i1042.GetNotificationsUseCase(gh<_i660.NotificationRepository>()),
    );
    gh.factory<_i1042.LoadMoreNotificationsUseCase>(
      () => _i1042.LoadMoreNotificationsUseCase(
        gh<_i660.NotificationRepository>(),
      ),
    );
    gh.factory<_i1042.MarkAsReadUseCase>(
      () => _i1042.MarkAsReadUseCase(gh<_i660.NotificationRepository>()),
    );
    gh.factory<_i1042.DeleteNotificationUseCase>(
      () =>
          _i1042.DeleteNotificationUseCase(gh<_i660.NotificationRepository>()),
    );
    gh.factory<_i1042.ClearAllNotificationsUseCase>(
      () => _i1042.ClearAllNotificationsUseCase(
        gh<_i660.NotificationRepository>(),
      ),
    );
    gh.lazySingleton<_i417.AppSectionRepositoryContract>(
      () => _i67.AppSectionRepositoryImpl(
        gh<_i663.AppSectionRemoteDatasourceContract>(),
        gh<_i622.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i488.AuthRepository>(
      () => _i263.AuthRepositoryImpl(
        gh<_i961.AuthRemoteDataSource>(),
        gh<_i622.AuthLocalDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i1038.GetPostsUseCase>(
      () => _i1038.GetPostsUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.LoadMorePostsUseCase>(
      () => _i1038.LoadMorePostsUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.ToggleLikeUseCase>(
      () => _i1038.ToggleLikeUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.ToggleSaveUseCase>(
      () => _i1038.ToggleSaveUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.ToggleCommentUseCase>(
      () => _i1038.ToggleCommentUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.DeletePostUseCase>(
      () => _i1038.DeletePostUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.factory<_i1038.CreatePostUseCase>(
      () => _i1038.CreatePostUseCase(gh<_i963.CommunityRepository>()),
    );
    gh.lazySingleton<_i18.ArticlesRepository>(
      () => _i625.ArticleRepositoryImpl(
        gh<_i159.ArticleRemoteDataSourceContract>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i480.LogoutUseCase>(
      () => _i480.LogoutUseCase(gh<_i417.AppSectionRepositoryContract>()),
    );
    gh.factory<_i473.NotificationCubit>(
      () => _i473.NotificationCubit(
        gh<_i1042.GetNotificationsUseCase>(),
        gh<_i1042.LoadMoreNotificationsUseCase>(),
        gh<_i1042.MarkAsReadUseCase>(),
        gh<_i1042.DeleteNotificationUseCase>(),
        gh<_i1042.ClearAllNotificationsUseCase>(),
      ),
    );
    gh.factory<_i1026.CommunityCubit>(
      () => _i1026.CommunityCubit(
        gh<_i1038.GetPostsUseCase>(),
        gh<_i1038.LoadMorePostsUseCase>(),
        gh<_i1038.ToggleLikeUseCase>(),
        gh<_i1038.ToggleSaveUseCase>(),
        gh<_i1038.ToggleCommentUseCase>(),
        gh<_i1038.DeletePostUseCase>(),
        gh<_i1038.CreatePostUseCase>(),
      ),
    );
    gh.factory<_i812.GetAssessmentByIdUseCase>(
      () => _i812.GetAssessmentByIdUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i156.GetAssessmentResultUseCase>(
      () => _i156.GetAssessmentResultUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i9.GetAssessmentsUseCase>(
      () => _i9.GetAssessmentsUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i895.GetOptionsUseCase>(
      () => _i895.GetOptionsUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i552.GetQuestionByIdUseCase>(
      () => _i552.GetQuestionByIdUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i670.GetQuestionsUseCase>(
      () => _i670.GetQuestionsUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i331.SubmitAssessmentUseCase>(
      () => _i331.SubmitAssessmentUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.factory<_i458.QuestionsCubit>(
      () => _i458.QuestionsCubit(
        gh<_i670.GetQuestionsUseCase>(),
        gh<_i895.GetOptionsUseCase>(),
      ),
    );
    gh.factory<_i989.BiometricLoginUseCase>(
      () => _i989.BiometricLoginUseCase(
        gh<_i488.AuthRepository>(),
        gh<_i792.BiometricHelper>(),
      ),
    );
    gh.factory<_i434.LogoutCubit>(
      () => _i434.LogoutCubit(
        gh<_i480.LogoutUseCase>(),
        gh<_i435.AppSectionLocalDatasourceContract>(),
      ),
    );
    gh.factory<_i292.CreateChildUseCase>(
      () => _i292.CreateChildUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i103.DeleteChildUseCase>(
      () => _i103.DeleteChildUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i698.GetChildUseCase>(
      () => _i698.GetChildUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i1057.GetChildrenUseCase>(
      () => _i1057.GetChildrenUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i157.UploadChildPhotoUseCase>(
      () => _i157.UploadChildPhotoUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i157.DeleteChildPhotoUseCase>(
      () => _i157.DeleteChildPhotoUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i178.UpdateChildUseCase>(
      () => _i178.UpdateChildUseCase(gh<_i889.ChildrenRepository>()),
    );
    gh.factory<_i562.SubmitCubit>(
      () => _i562.SubmitCubit(gh<_i331.SubmitAssessmentUseCase>()),
    );
    gh.factory<_i139.ChangePasswordUsecase>(
      () =>
          _i139.ChangePasswordUsecase(gh<_i417.AppSectionRepositoryContract>()),
    );
    gh.factory<_i319.GetProfileUsecase>(
      () => _i319.GetProfileUsecase(gh<_i417.AppSectionRepositoryContract>()),
    );
    gh.factory<_i84.UpdateProfileUsecase>(
      () => _i84.UpdateProfileUsecase(gh<_i417.AppSectionRepositoryContract>()),
    );
    gh.factory<_i650.ManageProfileCubit>(
      () => _i650.ManageProfileCubit(
        gh<_i84.UpdateProfileUsecase>(),
        gh<_i139.ChangePasswordUsecase>(),
      ),
    );
    gh.lazySingleton<_i849.ChangePasswordUseCase>(
      () => _i849.ChangePasswordUseCase(gh<_i488.AuthRepository>()),
    );
    gh.lazySingleton<_i385.ForgotPasswordUseCase>(
      () => _i385.ForgotPasswordUseCase(gh<_i488.AuthRepository>()),
    );
    gh.lazySingleton<_i364.GoogleLoginUseCase>(
      () => _i364.GoogleLoginUseCase(gh<_i488.AuthRepository>()),
    );
    gh.lazySingleton<_i19.ResendOtpUseCase>(
      () => _i19.ResendOtpUseCase(gh<_i488.AuthRepository>()),
    );
    gh.lazySingleton<_i420.ResetPasswordUseCase>(
      () => _i420.ResetPasswordUseCase(gh<_i488.AuthRepository>()),
    );
    gh.lazySingleton<_i804.RevokeTokenUseCase>(
      () => _i804.RevokeTokenUseCase(gh<_i488.AuthRepository>()),
    );
    gh.factory<_i398.LoginUseCase>(
      () => _i398.LoginUseCase(gh<_i488.AuthRepository>()),
    );
    gh.factory<_i584.RegisterUseCase>(
      () => _i584.RegisterUseCase(gh<_i488.AuthRepository>()),
    );
    gh.factory<_i352.VerifyEmailUseCase>(
      () => _i352.VerifyEmailUseCase(gh<_i488.AuthRepository>()),
    );
    gh.factory<_i875.GetArticlesByCategoryUseCase>(
      () => _i875.GetArticlesByCategoryUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i875.GetArticleByIdUseCase>(
      () => _i875.GetArticleByIdUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i875.SaveArticleUseCase>(
      () => _i875.SaveArticleUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i875.UnsaveArticleUseCase>(
      () => _i875.UnsaveArticleUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i875.GetSavedArticlesUseCase>(
      () => _i875.GetSavedArticlesUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i537.GetArticlesCategoryUsecase>(
      () => _i537.GetArticlesCategoryUsecase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i695.SearchArticlesUseCase>(
      () => _i695.SearchArticlesUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i361.GetSearchHistoryUseCase>(
      () => _i361.GetSearchHistoryUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i361.SaveSearchQueryUseCase>(
      () => _i361.SaveSearchQueryUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i361.ClearSearchHistoryUseCase>(
      () => _i361.ClearSearchHistoryUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i361.RemoveSearchTermUseCase>(
      () => _i361.RemoveSearchTermUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.factory<_i839.WatchArticleSaveStatusUseCase>(
      () => _i839.WatchArticleSaveStatusUseCase(gh<_i18.ArticlesRepository>()),
    );
    gh.lazySingleton<_i555.ChildrenCubit>(
      () => _i555.ChildrenCubit(
        gh<_i1057.GetChildrenUseCase>(),
        gh<_i292.CreateChildUseCase>(),
        gh<_i178.UpdateChildUseCase>(),
        gh<_i103.DeleteChildUseCase>(),
        gh<_i157.UploadChildPhotoUseCase>(),
        gh<_i157.DeleteChildPhotoUseCase>(),
      ),
    );
    gh.factory<_i964.CategoryCubit>(
      () => _i964.CategoryCubit(gh<_i537.GetArticlesCategoryUsecase>()),
    );
    gh.factory<_i850.HomeArticlesCubit>(
      () => _i850.HomeArticlesCubit(
        gh<_i537.GetArticlesCategoryUsecase>(),
        gh<_i875.GetArticlesByCategoryUseCase>(),
      ),
    );
    gh.factory<_i973.SavedArticlesCubit>(
      () => _i973.SavedArticlesCubit(
        gh<_i875.GetSavedArticlesUseCase>(),
        gh<_i875.SaveArticleUseCase>(),
        gh<_i875.UnsaveArticleUseCase>(),
        gh<_i839.WatchArticleSaveStatusUseCase>(),
      ),
    );
    gh.factory<_i550.AssessmentsCubit>(
      () => _i550.AssessmentsCubit(gh<_i9.GetAssessmentsUseCase>()),
    );
    gh.factory<_i712.AssessmentResultCubit>(
      () => _i712.AssessmentResultCubit(gh<_i156.GetAssessmentResultUseCase>()),
    );
    gh.factory<_i187.ArticleDetailCubit>(
      () => _i187.ArticleDetailCubit(
        gh<_i875.GetArticleByIdUseCase>(),
        gh<_i875.SaveArticleUseCase>(),
        gh<_i875.UnsaveArticleUseCase>(),
        gh<_i839.WatchArticleSaveStatusUseCase>(),
      ),
    );
    gh.factory<_i982.SearchArticlesCubit>(
      () => _i982.SearchArticlesCubit(
        gh<_i695.SearchArticlesUseCase>(),
        gh<_i361.GetSearchHistoryUseCase>(),
        gh<_i361.SaveSearchQueryUseCase>(),
        gh<_i361.ClearSearchHistoryUseCase>(),
        gh<_i361.RemoveSearchTermUseCase>(),
        gh<_i875.SaveArticleUseCase>(),
        gh<_i875.UnsaveArticleUseCase>(),
        gh<_i839.WatchArticleSaveStatusUseCase>(),
      ),
    );
    gh.lazySingleton<_i580.ProfileCubit>(
      () => _i580.ProfileCubit(gh<_i319.GetProfileUsecase>()),
    );
    gh.factory<_i47.AuthCubit>(
      () => _i47.AuthCubit(
        gh<_i398.LoginUseCase>(),
        gh<_i584.RegisterUseCase>(),
        gh<_i352.VerifyEmailUseCase>(),
        gh<_i385.ForgotPasswordUseCase>(),
        gh<_i420.ResetPasswordUseCase>(),
        gh<_i19.ResendOtpUseCase>(),
        gh<_i364.GoogleLoginUseCase>(),
        gh<_i849.ChangePasswordUseCase>(),
        gh<_i804.RevokeTokenUseCase>(),
        gh<_i989.BiometricLoginUseCase>(),
      ),
    );
    gh.factory<_i612.CategoryArticlesCubit>(
      () => _i612.CategoryArticlesCubit(
        gh<_i875.GetArticlesByCategoryUseCase>(),
        gh<_i875.SaveArticleUseCase>(),
        gh<_i875.UnsaveArticleUseCase>(),
        gh<_i839.WatchArticleSaveStatusUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
