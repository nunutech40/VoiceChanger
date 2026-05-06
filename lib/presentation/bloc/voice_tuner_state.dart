import 'package:equatable/equatable.dart';
import '../../domain/entities/audio_filter_entity.dart';

class VoiceTunerState extends Equatable {
  final AudioFilterEntity currentFilter;
  final bool isPlaying;
  final String? exportMessage;
  final bool isExporting;

  const VoiceTunerState({
    required this.currentFilter,
    required this.isPlaying,
    this.exportMessage,
    this.isExporting = false,
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
    String? exportMessage,
    bool? isExporting,
  }) {
    return VoiceTunerState(
      currentFilter: currentFilter ?? this.currentFilter,
      isPlaying: isPlaying ?? this.isPlaying,
      exportMessage: exportMessage,
      isExporting: isExporting ?? this.isExporting,
    );
  }

  @override
  List<Object?> get props => [currentFilter, isPlaying, exportMessage, isExporting];
}
