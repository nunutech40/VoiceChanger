import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/package:path_provider.dart';
import 'package:file_picker/file_picker.dart';

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
      await fetchHistory();
    } catch (e) {
      emit(AuraVoiceError("Gagal memanaskan mesin C++: ${e.toString()}"));
    }
  }

  Future<void> fetchHistory() async {
    try {
      final extDir = await getApplicationDocumentsDirectory();
      final files = extDir.listSync().where((item) {
        return item.path.endsWith('.m4a') || item.path.endsWith('.wav') || item.path.endsWith('.mp3');
      }).map((item) => item.path).toList();
      
      // Urutkan dari yang terbaru
      files.sort((a, b) => File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()));
      
      emit(AuraVoiceReady(historyFiles: files));
    } catch (e) {
      emit(const AuraVoiceReady(historyFiles: []));
    }
  }

  Future<void> pickExternalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      
      // Salin ke document directory agar masuk history
      final extDir = await getApplicationDocumentsDirectory();
      final fileName = result.files.single.name;
      final newPath = '${extDir.path}/$fileName';
      
      await File(path).copy(newPath);
      
      emit(AuraVoicePlayback(newPath));
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
}
