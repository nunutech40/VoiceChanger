import '../repositories/i_audio_repository.dart';
import '../entities/audio_filter_entity.dart';

class ExportAudioUseCase {
  final IAudioRepository repository;

  ExportAudioUseCase(this.repository);

  Future<String> execute(String sourcePath, AudioFilterEntity filter) async {
    return await repository.exportAudio(sourcePath, filter.pitch, filter.speed);
  }
}
