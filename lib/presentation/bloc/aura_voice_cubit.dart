import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/init_engine_usecase.dart';
import '../../domain/usecases/get_audio_history_usecase.dart';
import '../../domain/usecases/pick_external_audio_usecase.dart';
import '../../domain/usecases/start_recording_usecase.dart';
import '../../domain/usecases/stop_recording_usecase.dart';
import '../../domain/usecases/delete_audio_usecase.dart';
import 'aura_voice_state.dart';

class AuraVoiceCubit extends Cubit<AuraVoiceState> {
  final InitEngineUseCase _initEngineUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final GetAudioHistoryUseCase _getAudioHistoryUseCase;
  final PickExternalAudioUseCase _pickExternalAudioUseCase;
  final DeleteAudioUseCase _deleteAudioUseCase;

  AuraVoiceCubit(
    this._initEngineUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._getAudioHistoryUseCase,
    this._pickExternalAudioUseCase,
    this._deleteAudioUseCase,
  ) : super(AuraVoiceInitial());

  /// Inisialisasi engine C++ saat aplikasi dibuka
  Future<void> initEngine() async {
    try {
      await _initEngineUseCase.execute();
      await fetchHistory();
    } catch (e) {
      emit(AuraVoiceError("Gagal memanaskan mesin C++: ${e.toString()}"));
    }
  }

  Future<void> fetchHistory() async {
    try {
      final files = await _getAudioHistoryUseCase.execute();
      emit(AuraVoiceReady(historyFiles: files));
    } catch (e) {
      emit(const AuraVoiceReady(historyFiles: []));
    }
  }

  Future<void> pickExternalFile() async {
    try {
      final path = await _pickExternalAudioUseCase.execute();
      if (path != null) {
        emit(AuraVoicePlayback(path));
      }
    } catch (e) {
      emit(AuraVoiceError("Gagal import audio: ${e.toString()}"));
      emit(AuraVoiceReady());
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
    fetchHistory();
  }

  Future<void> deleteAudio(String path) async {
    try {
      await _deleteAudioUseCase.execute(path);
      await fetchHistory(); // Refresh history
    } catch (e) {
      emit(AuraVoiceError("Gagal menghapus file: ${e.toString()}"));
      await fetchHistory();
    }
  }
}
