import 'package:equatable/equatable.dart';

abstract class AuraVoiceState extends Equatable {
  const AuraVoiceState();

  @override
  List<Object?> get props => [];
}

class AuraVoiceInitial extends AuraVoiceState {}

class AuraVoiceReady extends AuraVoiceState {}

class AuraVoiceRecording extends AuraVoiceState {}

class AuraVoicePlayback extends AuraVoiceState {
  final String filePath;

  const AuraVoicePlayback(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class AuraVoiceError extends AuraVoiceState {
  final String message;

  const AuraVoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
