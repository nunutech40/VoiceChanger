import '../repositories/i_audio_repository.dart';

class PickExternalAudioUseCase {
  final IAudioRepository _repository;

  PickExternalAudioUseCase(this._repository);

  Future<String?> execute() {
    return _repository.pickExternalAudio();
  }
}
