import 'package:get_it/get_it.dart';
import 'package:voice_changer/data/datasources/audio_native_datasource.dart';
import 'package:voice_changer/data/repositories/audio_repository_impl.dart';
import 'package:voice_changer/domain/repositories/i_audio_repository.dart';
import 'package:voice_changer/domain/usecases/init_engine_usecase.dart';
import 'package:voice_changer/domain/usecases/start_recording_usecase.dart';
import 'package:voice_changer/domain/usecases/stop_recording_usecase.dart';
import 'package:voice_changer/domain/usecases/play_audio_usecase.dart';
import 'package:voice_changer/domain/usecases/stop_audio_usecase.dart';
import 'package:voice_changer/domain/usecases/apply_voice_filter_usecase.dart';
import 'package:voice_changer/domain/usecases/get_audio_history_usecase.dart';
import 'package:voice_changer/domain/usecases/pick_external_audio_usecase.dart';
import 'package:voice_changer/domain/usecases/delete_audio_usecase.dart';
import 'package:voice_changer/presentation/bloc/aura_voice_cubit.dart';
import 'package:voice_changer/presentation/bloc/voice_tuner_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit
  sl.registerFactory(() => AuraVoiceCubit(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => VoiceTunerCubit(sl(), sl(), sl()));

  // UseCases
  sl.registerLazySingleton(() => InitEngineUseCase(sl()));
  sl.registerLazySingleton(() => StartRecordingUseCase(sl()));
  sl.registerLazySingleton(() => StopRecordingUseCase(sl()));
  sl.registerLazySingleton(() => PlayAudioUseCase(sl()));
  sl.registerLazySingleton(() => StopAudioUseCase(sl()));
  sl.registerLazySingleton(() => ApplyVoiceFilterUseCase(sl()));
  sl.registerLazySingleton(() => GetAudioHistoryUseCase(sl()));
  sl.registerLazySingleton(() => PickExternalAudioUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAudioUseCase(sl()));

  // Data Sources
  sl.registerLazySingleton<AudioNativeDataSource>(
      () => AudioNativeDataSource());

  // Repositories
  sl.registerLazySingleton<IAudioRepository>(
      () => AudioRepositoryImpl(sl()));
}
