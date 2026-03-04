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

import '../../feature/baby_cry/data/data_source/audio_local_data_source.dart'
    as _i96;
import '../../feature/baby_cry/data/data_source/audio_local_data_source_impl.dart'
    as _i881;
import '../../feature/baby_cry/data/repository/audio_repository.dart' as _i0;
import '../../feature/baby_cry/data/repository/audio_repository_impl.dart'
    as _i636;
import '../../feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart'
    as _i589;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i1039.AudioRecorder>(() => appModule.audioRecorder);
    gh.lazySingleton<_i96.AudioLocalDataSource>(
      () => _i881.AudioLocalDataSourceImpl(gh<_i1039.AudioRecorder>()),
    );
    gh.lazySingleton<_i0.AudioRepository>(
      () => _i636.AudioRepositoryImpl(gh<_i96.AudioLocalDataSource>()),
    );
    gh.factory<_i589.SoundRecordingCubit>(
      () => _i589.SoundRecordingCubit(gh<_i0.AudioRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
