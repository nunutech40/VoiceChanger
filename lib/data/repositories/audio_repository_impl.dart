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
}
