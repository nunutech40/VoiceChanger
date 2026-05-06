import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/audio_filter_entity.dart';
import '../../domain/usecases/apply_voice_filter_usecase.dart';
import '../../domain/usecases/play_audio_usecase.dart';
import '../../domain/usecases/stop_audio_usecase.dart';
import 'voice_tuner_state.dart';

class VoiceTunerCubit extends Cubit<VoiceTunerState> {
  final PlayAudioUseCase _playAudioUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final ApplyVoiceFilterUseCase _applyVoiceFilterUseCase;

  String? _currentAudioPath;

  VoiceTunerCubit(
    this._playAudioUseCase,
    this._stopAudioUseCase,
    this._applyVoiceFilterUseCase,
  ) : super(VoiceTunerState.initial());

  void setAudioPath(String path) {
    _currentAudioPath = path;
  }

  Future<void> play() async {
    if (_currentAudioPath == null) return;
    
    // Play the audio
    await _playAudioUseCase.execute(_currentAudioPath!);
    
    // Apply current filter synchronously
    _applyVoiceFilterUseCase.execute(state.currentFilter);
    
    emit(state.copyWith(isPlaying: true));
  }

  Future<void> stop() async {
    await _stopAudioUseCase.execute();
    emit(state.copyWith(isPlaying: false));
  }

  void applyTemplate(AudioFilterEntity filter) {
    // Update State
    emit(state.copyWith(currentFilter: filter));
    
    // If it's playing, apply immediately via FFI
    if (state.isPlaying) {
      _applyVoiceFilterUseCase.execute(filter);
    } else {
      // Auto play when template is pressed (based on PRD requirements)
      play();
    }
  }

  void applyCustomTune(double pitch, double speed) {
    final newFilter = state.currentFilter.copyWith(pitch: pitch, speed: speed);
    emit(state.copyWith(currentFilter: newFilter));
    
    if (state.isPlaying) {
      _applyVoiceFilterUseCase.execute(newFilter);
    }
  }
}
