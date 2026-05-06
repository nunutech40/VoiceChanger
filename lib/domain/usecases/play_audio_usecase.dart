import '../repositories/i_audio_repository.dart';

class PlayAudioUseCase {
  final IAudioRepository repository;

  PlayAudioUseCase(this.repository);

  Future<void> execute(String path) async {
    await repository.playAudio(path);
  }
}
