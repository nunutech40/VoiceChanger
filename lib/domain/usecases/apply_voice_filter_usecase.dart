import '../entities/audio_filter_entity.dart';
import '../repositories/i_audio_repository.dart';

class ApplyVoiceFilterUseCase {
  final IAudioRepository repository;

  ApplyVoiceFilterUseCase(this.repository);

  void execute(AudioFilterEntity filter) {
    repository.applyPitchAndSpeed(filter.pitch, filter.speed);
  }
}
