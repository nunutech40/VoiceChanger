import 'package:equatable/equatable.dart';

class AudioFilterEntity extends Equatable {
  final double pitch;
  final double speed;

  const AudioFilterEntity({
    required this.pitch,
    required this.speed,
  });

  // Template: Normal
  factory AudioFilterEntity.normal() => const AudioFilterEntity(pitch: 1.0, speed: 1.0);
  
  // Template: Tupai (Chipmunk)
  factory AudioFilterEntity.chipmunk() => const AudioFilterEntity(pitch: 2.0, speed: 1.5);
  
  // Template: Monster
  factory AudioFilterEntity.monster() => const AudioFilterEntity(pitch: 0.5, speed: 0.8);
  
  // Template: Robot
  factory AudioFilterEntity.robot() => const AudioFilterEntity(pitch: 1.2, speed: 1.0);

  AudioFilterEntity copyWith({
    double? pitch,
    double? speed,
  }) {
    return AudioFilterEntity(
      pitch: pitch ?? this.pitch,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [pitch, speed];
}
