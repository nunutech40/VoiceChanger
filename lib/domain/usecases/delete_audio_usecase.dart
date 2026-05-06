import '../repositories/i_audio_repository.dart';

class DeleteAudioUseCase {
  final IAudioRepository _repository;

  DeleteAudioUseCase(this._repository);

  Future<void> execute(String path) async {
    await _repository.deleteAudio(path);
  }
}
