import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/init_engine_usecase.dart';
import '../../domain/usecases/start_recording_usecase.dart';
import '../../domain/usecases/stop_recording_usecase.dart';
import 'aura_voice_state.dart';

class AuraVoiceCubit extends Cubit<AuraVoiceState> {
  final InitEngineUseCase _initEngineUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;

  AuraVoiceCubit(
    this._initEngineUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
  ) : super(AuraVoiceInitial());

  /// Inisialisasi engine C++ saat aplikasi dibuka
  Future<void> initEngine() async {
    try {
      await _initEngineUseCase.execute();
      emit(AuraVoiceReady());
    } catch (e) {
      emit(AuraVoiceError("Gagal memanaskan mesin C++: ${e.toString()}"));
    }
  }

  /// Mulai rekaman suara
  Future<void> startRecording() async {
    try {
      await _startRecordingUseCase.execute();
      emit(AuraVoiceRecording());
    } catch (e) {
      emit(AuraVoiceError("Gagal merekam: ${e.toString()}"));
      emit(AuraVoiceReady()); // Kembalikan ke state siap jika gagal
    }
  }

  /// Hentikan rekaman dan simpan path-nya
  Future<void> stopRecording() async {
    try {
      final path = await _stopRecordingUseCase.execute();
      if (path != null) {
        emit(AuraVoicePlayback(path));
      } else {
        emit(const AuraVoiceError("Gagal menyimpan file rekaman."));
        emit(AuraVoiceReady());
      }
    } catch (e) {
      emit(AuraVoiceError(e.toString()));
      emit(AuraVoiceReady());
    }
  }

  /// Kembali ke halaman rekaman awal
  void resetToReady() {
    emit(AuraVoiceReady());
  }
}
