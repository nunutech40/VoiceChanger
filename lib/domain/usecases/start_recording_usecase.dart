import '../repositories/i_audio_repository.dart';

class StartRecordingUseCase {
  final IAudioRepository repository;

  StartRecordingUseCase(this.repository);

  Future<void> execute() async {
    return await repository.startRecording();
  }
}
