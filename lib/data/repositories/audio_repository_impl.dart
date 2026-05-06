import '../../domain/repositories/i_audio_repository.dart';
import '../datasources/audio_native_datasource.dart';

class AudioRepositoryImpl implements IAudioRepository {
  final AudioNativeDataSource _dataSource;

  AudioRepositoryImpl(this._dataSource);

  @override
  Future<void> initEngine() async {
    await _dataSource.initEngine();
  }

  @override
  Future<void> disposeEngine() async {
    await _dataSource.disposeEngine();
  }

  @override
  Future<void> startRecording() async {
    await _dataSource.startRecording();
  }

  @override
  Future<String?> stopRecording() async {
    return await _dataSource.stopRecording();
  }

  @override
  Future<void> playAudio(String path) async {
    await _dataSource.playAudio(path);
  }

  @override
  Future<void> stopAudio() async {
    await _dataSource.stopAudio();
  }

  @override
  void applyPitchAndSpeed(double pitch, double speed) {
    _dataSource.applyPitchAndSpeed(pitch, speed);
  }

  @override
  Future<String> exportAudio(String sourcePath, double pitch, double speed) async {
    return await _dataSource.exportAudio(sourcePath, pitch, speed);
  }

  @override
  Future<List<String>> getAudioHistory() async {
    return await _dataSource.getAudioHistory();
  }

  @override
  Future<String?> pickExternalAudio() async {
    return await _dataSource.pickExternalAudio();
  }
}
