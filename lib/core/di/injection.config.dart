// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:record/record.dart' as _i1039;

import '../../feature/articles/data/datasource/article_local_datasource.dart'
    as _i921;
import '../../feature/articles/data/repository/article_repository.dart' as _i95;
import '../../feature/articles/data/repository/article_repository_impl.dart'
    as _i625;
import '../../feature/articles/domain/usecases/article_usecases.dart' as _i875;
import '../../feature/articles/presentation/view_model/article_cubit.dart'
    as _i490;
import '../../feature/baby_cry/data/data_source/audio_local_data_source.dart'
    as _i96;
import '../../feature/baby_cry/data/data_source/audio_local_data_source_impl.dart'
    as _i881;
import '../../feature/baby_cry/data/repository/audio_repository.dart' as _i0;
import '../../feature/baby_cry/data/repository/audio_repository_impl.dart'
    as _i636;
import '../../feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart'
    as _i589;
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
import '../localization/cubit/language_cubit.dart' as _i866;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i386.ProfileCubit>(() => _i386.ProfileCubit());
    gh.lazySingleton<_i1039.AudioRecorder>(() => appModule.audioRecorder);
    gh.lazySingleton<_i866.LanguageCubit>(() => _i866.LanguageCubit());
    gh.lazySingleton<_i921.ArticleLocalDataSource>(
      () => _i921.ArticleLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i97.CommunityLocalDataSource>(
      () => _i97.CommunityLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i967.NotificationLocalDataSource>(
      () => _i967.NotificationLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i660.NotificationRepository>(
      () => _i679.NotificationRepositoryImpl(
        gh<_i967.NotificationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i96.AudioLocalDataSource>(
      () => _i881.AudioLocalDataSourceImpl(gh<_i1039.AudioRecorder>()),
    );
    gh.lazySingleton<_i95.ArticleRepository>(
      () => _i625.ArticleRepositoryImpl(gh<_i921.ArticleLocalDataSource>()),
    );
    gh.lazySingleton<_i963.CommunityRepository>(
      () => _i272.CommunityRepositoryImpl(gh<_i97.CommunityLocalDataSource>()),
    );
    gh.lazySingleton<_i0.AudioRepository>(
      () => _i636.AudioRepositoryImpl(gh<_i96.AudioLocalDataSource>()),
    );
    gh.factory<_i589.SoundRecordingCubit>(
      () => _i589.SoundRecordingCubit(gh<_i0.AudioRepository>()),
    );
    gh.factory<_i875.GetArticlesUseCase>(
      () => _i875.GetArticlesUseCase(gh<_i95.ArticleRepository>()),
    );
    gh.factory<_i875.ToggleSaveArticleUseCase>(
      () => _i875.ToggleSaveArticleUseCase(gh<_i95.ArticleRepository>()),
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
    gh.factory<_i490.ArticleCubit>(
      () => _i490.ArticleCubit(
        gh<_i875.GetArticlesUseCase>(),
        gh<_i875.ToggleSaveArticleUseCase>(),
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
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
