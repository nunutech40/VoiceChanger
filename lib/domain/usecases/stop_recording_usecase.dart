import '../repositories/i_audio_repository.dart';

class StopRecordingUseCase {
  final IAudioRepository repository;

  StopRecordingUseCase(this.repository);

  /// Mengembalikan path file audio yang berhasil direkam.
  Future<String?> execute() async {
    return await repository.stopRecording();
  }
}
