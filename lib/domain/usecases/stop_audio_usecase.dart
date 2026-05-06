import '../repositories/i_audio_repository.dart';

class StopAudioUseCase {
  final IAudioRepository repository;

  StopAudioUseCase(this.repository);

  Future<void> execute() async {
    await repository.stopAudio();
  }
}
