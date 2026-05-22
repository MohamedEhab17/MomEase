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
import '../../feature/baby_track/data/datasources/vaccination_remote_data_source_contract.dart'
    as _i450;
import '../../feature/baby_track/data/datasources/vaccination_remote_data_source_impl.dart'
    as _i3;
import '../../feature/baby_track/data/repositories/vaccination_repository_impl.dart'
    as _i767;
import '../../feature/baby_track/domain/repositories/vaccination_repository.dart'
    as _i378;
import '../../feature/baby_track/domain/usecase/get_completed_vaccinations_usecase.dart'
    as _i413;
import '../../feature/baby_track/domain/usecase/get_overdue_vaccinations_usecase.dart'
    as _i227;
import '../../feature/baby_track/domain/usecase/get_upcoming_vaccinations_usecase.dart'
    as _i120;
import '../../feature/baby_track/domain/usecase/get_vaccination_details_usecase.dart'
    as _i340;
import '../../feature/baby_track/domain/usecase/get_vaccinations_usecase.dart'
    as _i1023;
import '../../feature/baby_track/domain/usecase/mark_vaccination_taken_usecase.dart'
    as _i1015;
import '../../feature/baby_track/domain/usecase/update_vaccination_status_usecase.dart'
    as _i976;
import '../../feature/baby_track/presentation/view_model/vaccinations_cubit/vaccinations_cubit.dart'
    as _i423;
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
import '../../feature/community/data/datasource/community_remote_datasource.dart'
    as _i108;
import '../../feature/community/data/repository/community_repository_impl.dart'
    as _i272;
import '../../feature/community/domain/repository/community_repository.dart'
    as _i59;
import '../../feature/community/domain/usecase/community_usecases.dart'
    as _i728;
import '../../feature/community/presentation/view_model/comments_cubit.dart'
    as _i37;
import '../../feature/community/presentation/view_model/community_cubit.dart'
    as _i1026;
import '../../feature/community/presentation/view_model/post_details_cubit/post_details_cubit.dart'
    as _i585;
import '../../feature/depression/data/datasources/assessment_remote_data_source_contract.dart'
    as _i766;
import '../../feature/depression/data/datasources/assessment_remote_data_source_impl.dart'
    as _i730;
import '../../feature/depression/data/repositories/assessments_repository_impl.dart'
    as _i501;
import '../../feature/depression/domain/repositories/assessment_repository.dart'
    as _i121;
import '../../feature/depression/domain/usecase/delete_assessment_result_usecase.dart'
    as _i772;
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
import '../../feature/depression/domain/usecase/get_user_assessment_results_usecase.dart'
    as _i1019;
import '../../feature/depression/domain/usecase/submit_assessment_usecase.dart'
    as _i331;
import '../../feature/depression/presentation/view_model/assessment_result_cubit/assessment_result_cubit.dart'
    as _i712;
import '../../feature/depression/presentation/view_model/assessments_cubit/assessments_cubit.dart'
    as _i550;
import '../../feature/depression/presentation/view_model/depression_history_cubit/depression_history_cubit.dart'
    as _i712;
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
import '../../feature/profile/data/datasource/profile_remote_datasource.dart'
    as _i936;
import '../../feature/profile/data/repository/profile_repository_impl.dart'
    as _i681;
import '../../feature/profile/domain/repository/profile_repository.dart'
    as _i244;
import '../../feature/profile/domain/usecase/profile_usecases.dart' as _i132;
import '../../feature/profile/presentation/view_model/profile_cubit.dart'
    as _i386;
import '../../feature/skin_diagnosis/data/datasources/skin_analysis_remote_data_source.dart'
    as _i393;
import '../../feature/skin_diagnosis/data/datasources/skin_analysis_remote_data_source_impl.dart'
    as _i935;
import '../../feature/skin_diagnosis/data/repositories/skin_analysis_repository_impl.dart'
    as _i608;
import '../../feature/skin_diagnosis/domain/repositories/skin_analysis_repository.dart'
    as _i1059;
import '../../feature/skin_diagnosis/domain/usecases/analyze_skin_image_usecase.dart'
    as _i820;
import '../../feature/skin_diagnosis/domain/usecases/delete_skin_analysis_usecase.dart'
    as _i517;
import '../../feature/skin_diagnosis/domain/usecases/get_child_skin_analyses_usecase.dart'
    as _i543;
import '../../feature/skin_diagnosis/domain/usecases/get_user_skin_analyses_usecase.dart'
    as _i782;
import '../../feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart'
    as _i846;
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
    gh.lazySingleton<_i936.ProfileRemoteDataSource>(
      () => _i936.ProfileRemoteDataSourceImpl(gh<_i557.ApiClient>()),
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
    gh.lazySingleton<_i244.ProfileRepository>(
      () => _i681.ProfileRepositoryImpl(gh<_i936.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i792.BiometricHelper>(
      () => _i792.BiometricHelper(gh<_i152.LocalAuthentication>()),
    );
    gh.factory<_i132.GetMotherProfileUseCase>(
      () => _i132.GetMotherProfileUseCase(gh<_i244.ProfileRepository>()),
    );
    gh.factory<_i132.UpdateMotherProfileUseCase>(
      () => _i132.UpdateMotherProfileUseCase(gh<_i244.ProfileRepository>()),
    );
    gh.factory<_i132.UploadProfilePhotoUseCase>(
      () => _i132.UploadProfilePhotoUseCase(gh<_i244.ProfileRepository>()),
    );
    gh.factory<_i132.DeleteProfilePhotoUseCase>(
      () => _i132.DeleteProfilePhotoUseCase(gh<_i244.ProfileRepository>()),
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
    gh.lazySingleton<_i108.CommunityRemoteDataSource>(
      () => _i108.CommunityRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i766.AssessmentRemoteDataSourceContract>(
      () => _i730.AssessmentRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i450.VaccinationRemoteDataSourceContract>(
      () => _i3.VaccinationRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i59.CommunityRepository>(
      () =>
          _i272.CommunityRepositoryImpl(gh<_i108.CommunityRemoteDataSource>()),
    );
    gh.lazySingleton<_i386.ProfileCubit>(
      () => _i386.ProfileCubit(
        gh<_i132.GetMotherProfileUseCase>(),
        gh<_i132.UpdateMotherProfileUseCase>(),
        gh<_i132.UploadProfilePhotoUseCase>(),
        gh<_i132.DeleteProfilePhotoUseCase>(),
      ),
    );
    gh.lazySingleton<_i393.SkinAnalysisRemoteDataSource>(
      () => _i935.SkinAnalysisRemoteDataSourceImpl(gh<_i557.ApiClient>()),
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
    gh.lazySingleton<_i772.DeleteAssessmentResultUseCase>(
      () =>
          _i772.DeleteAssessmentResultUseCase(gh<_i121.AssessmentRepository>()),
    );
    gh.lazySingleton<_i1019.GetUserAssessmentResultsUseCase>(
      () => _i1019.GetUserAssessmentResultsUseCase(
        gh<_i121.AssessmentRepository>(),
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
    gh.factory<_i712.DepressionHistoryCubit>(
      () => _i712.DepressionHistoryCubit(
        gh<_i1019.GetUserAssessmentResultsUseCase>(),
        gh<_i772.DeleteAssessmentResultUseCase>(),
      ),
    );
    gh.lazySingleton<_i488.AuthRepository>(
      () => _i263.AuthRepositoryImpl(
        gh<_i961.AuthRemoteDataSource>(),
        gh<_i622.AuthLocalDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i1059.SkinAnalysisRepository>(
      () => _i608.SkinAnalysisRepositoryImpl(
        gh<_i393.SkinAnalysisRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
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
    gh.lazySingleton<_i378.VaccinationRepository>(
      () => _i767.VaccinationRepositoryImpl(
        gh<_i450.VaccinationRemoteDataSourceContract>(),
        gh<_i932.NetworkInfo>(),
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
    gh.factory<_i728.GetPostsUseCase>(
      () => _i728.GetPostsUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetMyPostsUseCase>(
      () => _i728.GetMyPostsUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetPostByIdUseCase>(
      () => _i728.GetPostByIdUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.CreatePostUseCase>(
      () => _i728.CreatePostUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.UpdatePostUseCase>(
      () => _i728.UpdatePostUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.DeletePostUseCase>(
      () => _i728.DeletePostUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.AddReactionUseCase>(
      () => _i728.AddReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.UpdateReactionUseCase>(
      () => _i728.UpdateReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.RemoveReactionUseCase>(
      () => _i728.RemoveReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.ToggleSavePostUseCase>(
      () => _i728.ToggleSavePostUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetSavedPostsUseCase>(
      () => _i728.GetSavedPostsUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.ReportPostUseCase>(
      () => _i728.ReportPostUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetPostReactionsUseCase>(
      () => _i728.GetPostReactionsUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetCommentsUseCase>(
      () => _i728.GetCommentsUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.AddCommentUseCase>(
      () => _i728.AddCommentUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.UpdateCommentUseCase>(
      () => _i728.UpdateCommentUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.DeleteCommentUseCase>(
      () => _i728.DeleteCommentUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.AddCommentReactionUseCase>(
      () => _i728.AddCommentReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.UpdateCommentReactionUseCase>(
      () => _i728.UpdateCommentReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.RemoveCommentReactionUseCase>(
      () => _i728.RemoveCommentReactionUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.GetRepliesUseCase>(
      () => _i728.GetRepliesUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.AddReplyUseCase>(
      () => _i728.AddReplyUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.UpdateReplyUseCase>(
      () => _i728.UpdateReplyUseCase(gh<_i59.CommunityRepository>()),
    );
    gh.factory<_i728.DeleteReplyUseCase>(
      () => _i728.DeleteReplyUseCase(gh<_i59.CommunityRepository>()),
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
    gh.factory<_i37.CommentsCubit>(
      () => _i37.CommentsCubit(
        gh<_i728.GetCommentsUseCase>(),
        gh<_i728.AddCommentUseCase>(),
        gh<_i728.UpdateCommentUseCase>(),
        gh<_i728.DeleteCommentUseCase>(),
        gh<_i728.GetRepliesUseCase>(),
        gh<_i728.AddReplyUseCase>(),
        gh<_i728.UpdateReplyUseCase>(),
        gh<_i728.DeleteReplyUseCase>(),
        gh<_i728.AddCommentReactionUseCase>(),
        gh<_i728.UpdateCommentReactionUseCase>(),
        gh<_i728.RemoveCommentReactionUseCase>(),
      ),
    );
    gh.factory<_i650.ManageProfileCubit>(
      () => _i650.ManageProfileCubit(
        gh<_i84.UpdateProfileUsecase>(),
        gh<_i139.ChangePasswordUsecase>(),
      ),
    );
    gh.factory<_i820.AnalyzeSkinImageUseCase>(
      () => _i820.AnalyzeSkinImageUseCase(gh<_i1059.SkinAnalysisRepository>()),
    );
    gh.factory<_i517.DeleteSkinAnalysisUseCase>(
      () =>
          _i517.DeleteSkinAnalysisUseCase(gh<_i1059.SkinAnalysisRepository>()),
    );
    gh.factory<_i543.GetChildSkinAnalysesUseCase>(
      () => _i543.GetChildSkinAnalysesUseCase(
        gh<_i1059.SkinAnalysisRepository>(),
      ),
    );
    gh.factory<_i782.GetUserSkinAnalysesUseCase>(
      () =>
          _i782.GetUserSkinAnalysesUseCase(gh<_i1059.SkinAnalysisRepository>()),
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
    gh.factory<_i585.PostDetailsCubit>(
      () => _i585.PostDetailsCubit(gh<_i728.GetPostByIdUseCase>()),
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
    gh.factory<_i413.GetCompletedVaccinationsUseCase>(
      () => _i413.GetCompletedVaccinationsUseCase(
        gh<_i378.VaccinationRepository>(),
      ),
    );
    gh.factory<_i227.GetOverdueVaccinationsUseCase>(
      () => _i227.GetOverdueVaccinationsUseCase(
        gh<_i378.VaccinationRepository>(),
      ),
    );
    gh.factory<_i120.GetUpcomingVaccinationsUseCase>(
      () => _i120.GetUpcomingVaccinationsUseCase(
        gh<_i378.VaccinationRepository>(),
      ),
    );
    gh.factory<_i340.GetVaccinationDetailsUseCase>(
      () =>
          _i340.GetVaccinationDetailsUseCase(gh<_i378.VaccinationRepository>()),
    );
    gh.factory<_i1023.GetVaccinationsUseCase>(
      () => _i1023.GetVaccinationsUseCase(gh<_i378.VaccinationRepository>()),
    );
    gh.factory<_i1015.MarkVaccinationTakenUseCase>(
      () =>
          _i1015.MarkVaccinationTakenUseCase(gh<_i378.VaccinationRepository>()),
    );
    gh.factory<_i976.UpdateVaccinationStatusUseCase>(
      () => _i976.UpdateVaccinationStatusUseCase(
        gh<_i378.VaccinationRepository>(),
      ),
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
    gh.factory<_i1026.CommunityCubit>(
      () => _i1026.CommunityCubit(
        gh<_i728.GetPostsUseCase>(),
        gh<_i728.GetMyPostsUseCase>(),
        gh<_i728.CreatePostUseCase>(),
        gh<_i728.DeletePostUseCase>(),
        gh<_i728.AddReactionUseCase>(),
        gh<_i728.UpdateReactionUseCase>(),
        gh<_i728.RemoveReactionUseCase>(),
        gh<_i728.ToggleSavePostUseCase>(),
        gh<_i728.GetSavedPostsUseCase>(),
        gh<_i728.ReportPostUseCase>(),
      ),
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
    gh.factory<_i846.SkinDiagnosisCubit>(
      () => _i846.SkinDiagnosisCubit(
        gh<_i820.AnalyzeSkinImageUseCase>(),
        gh<_i782.GetUserSkinAnalysesUseCase>(),
        gh<_i543.GetChildSkinAnalysesUseCase>(),
        gh<_i517.DeleteSkinAnalysisUseCase>(),
      ),
    );
    gh.factory<_i423.VaccinationsCubit>(
      () => _i423.VaccinationsCubit(
        gh<_i1023.GetVaccinationsUseCase>(),
        gh<_i976.UpdateVaccinationStatusUseCase>(),
        gh<_i120.GetUpcomingVaccinationsUseCase>(),
        gh<_i227.GetOverdueVaccinationsUseCase>(),
        gh<_i413.GetCompletedVaccinationsUseCase>(),
        gh<_i1015.MarkVaccinationTakenUseCase>(),
      ),
    );
    gh.lazySingleton<_i47.AuthCubit>(
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
