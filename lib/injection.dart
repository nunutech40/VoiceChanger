import 'package:get_it/get_it.dart';
import 'package:voice_changer/data/datasources/audio_native_datasource.dart';
import 'package:voice_changer/data/repositories/audio_repository_impl.dart';
import 'package:voice_changer/domain/repositories/i_audio_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // TODO: Register BLoCs
  // sl.registerFactory(() => VoiceTunerCubit(sl()));

  // TODO: Register UseCases
  // sl.registerLazySingleton(() => ApplyVoiceFilterUseCase(sl()));

  // Data Sources
  sl.registerLazySingleton<AudioNativeDataSource>(
      () => AudioNativeDataSource());

  // Repositories
  sl.registerLazySingleton<IAudioRepository>(
      () => AudioRepositoryImpl(sl()));
}
