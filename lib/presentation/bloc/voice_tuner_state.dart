import 'package:equatable/equatable.dart';
import '../../domain/entities/audio_filter_entity.dart';

class VoiceTunerState extends Equatable {
  final AudioFilterEntity currentFilter;
  final bool isPlaying;
  const VoiceTunerState({
    required this.currentFilter,
    required this.isPlaying,
  });

  factory VoiceTunerState.initial() {
    return VoiceTunerState(
      currentFilter: AudioFilterEntity.normal(),
      isPlaying: false,
    );
  }

  VoiceTunerState copyWith({
    AudioFilterEntity? currentFilter,
    bool? isPlaying,
  }) {
    return VoiceTunerState(
      currentFilter: currentFilter ?? this.currentFilter,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [currentFilter, isPlaying];
}
