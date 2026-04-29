import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // TODO: Register BLoCs
  // sl.registerFactory(() => VoiceTunerCubit(sl()));

  // TODO: Register UseCases
  // sl.registerLazySingleton(() => ApplyVoiceFilterUseCase(sl()));

  // TODO: Register Repositories
  // sl.registerLazySingleton<IAudioRepository>(() => AudioRepositoryImpl(sl()));

  // TODO: Register Data Sources
  // sl.registerLazySingleton<AudioNativeDataSource>(() => AudioNativeDataSourceImpl());
}
