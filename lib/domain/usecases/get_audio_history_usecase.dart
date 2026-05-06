import '../repositories/i_audio_repository.dart';

class GetAudioHistoryUseCase {
  final IAudioRepository _repository;

  GetAudioHistoryUseCase(this._repository);

  Future<List<String>> execute() {
    return _repository.getAudioHistory();
  }
}
