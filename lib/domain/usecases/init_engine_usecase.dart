import '../repositories/i_audio_repository.dart';

class InitEngineUseCase {
  final IAudioRepository repository;

  InitEngineUseCase(this.repository);

  Future<void> execute() async {
    return await repository.initEngine();
  }
}
