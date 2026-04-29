import 'dart:io';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioNativeDataSource {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;

  /// Menginisialisasi SoLoud Engine (C++ DSP).
  Future<void> initEngine() async {
    final soloud = SoLoud.instance;
    if (!soloud.isInitialized) {
      await soloud.init();
    }
  }

  /// Membersihkan SoLoud Engine dari memori.
  Future<void> disposeEngine() async {
    final soloud = SoLoud.instance;
    if (soloud.isInitialized) {
      soloud.deinit();
    }
    _audioRecorder.dispose();
  }

  /// Memulai proses rekaman suara dari Microphone.
  Future<void> startRecording() async {
    // 1. Minta akses Microphone ke OS
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Akses Microphone ditolak oleh pengguna.');
    }

    // 2. Siapkan file temporary di Disk untuk menampung data
    final tempDir = await getTemporaryDirectory();
    _currentRecordingPath = '${tempDir.path}/aura_voice_temp.m4a';

    // 3. Mulai merekam ke file tersebut
    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // Kompresi ringan
          bitRate: 128000,
          sampleRate: 44100, // Standar Audio
        ),
        path: _currentRecordingPath!,
      );
    }
  }

  /// Menghentikan rekaman dan mengembalikan lokasi path file-nya.
  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }
}
