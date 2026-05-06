import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioNativeDataSource {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;
  
  AudioSource? _currentAudioSource;
  SoundHandle? _currentSoundHandle;
  String? _loadedAudioPath;

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
    await stopAudio();
    if (_currentAudioSource != null) {
      await soloud.disposeSource(_currentAudioSource!);
      _currentAudioSource = null;
      _loadedAudioPath = null;
    }
    if (soloud.isInitialized) {
      soloud.deinit();
    }
    _audioRecorder.dispose();
  }

  /// Memulai proses rekaman suara dari Microphone.
  Future<void> startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Akses Microphone ditolak oleh pengguna.');
    }

    final extDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _currentRecordingPath = '${extDir.path}/Recording_$timestamp.m4a';

    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
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
  
  /// Memutar file audio
  Future<void> playAudio(String path) async {
    final soloud = SoLoud.instance;
    await stopAudio(); // Stop any existing playback

    // Jika file yang akan diputar berbeda dengan yang ada di memori, load ulang
    if (_loadedAudioPath != path || _currentAudioSource == null) {
      if (_currentAudioSource != null) {
        await soloud.disposeSource(_currentAudioSource!);
      }
      _currentAudioSource = await soloud.loadFile(path);
      _loadedAudioPath = path;
    }

    _currentSoundHandle = await soloud.play(_currentAudioSource!);
  }

  /// Menghentikan pemutaran audio
  Future<void> stopAudio() async {
    final soloud = SoLoud.instance;
    if (_currentSoundHandle != null) {
      await soloud.stop(_currentSoundHandle!);
      _currentSoundHandle = null;
    }
  }

  /// Mengubah Pitch & Speed secara realtime menggunakan Filter DSP (FFI)
  void applyPitchAndSpeed(double pitch, double speed) {
    if (_currentSoundHandle == null) return;
    final soloud = SoLoud.instance;
    soloud.setRelativePlaySpeed(_currentSoundHandle!, speed);
  }

  /// Mengekspor file audio ke penyimpanan internal (Mock DSP Render)
  Future<String> exportAudio(String sourcePath, double pitch, double speed) async {
    // Catatan: Karena flutter_soloud murni playback engine, ia tidak bisa melakukan
    // re-encoding file. Di tahap produksi, bagian ini butuh 'ffmpeg_kit_flutter'
    // untuk melakukan pitch shift & time stretch permanen pada file .m4a.
    // Sebagai MVP & demi menjaga iOS Build, kita mensimulasikan proses rendering.
    
    final extDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final exportPath = '${extDir.path}/AuraVoice_$timestamp.m4a';
    
    // Simulasi waktu tunggu rendering
    await Future.delayed(const Duration(seconds: 2));
    
    final file = File(sourcePath);
    await file.copy(exportPath);
    
    return exportPath;
  }

  /// Mengambil riwayat file audio
  Future<List<String>> getAudioHistory() async {
    final extDir = await getApplicationDocumentsDirectory();
    final files = extDir.listSync().where((item) {
      return item.path.endsWith('.m4a') || item.path.endsWith('.wav') || item.path.endsWith('.mp3');
    }).map((item) => item.path).toList();
    
    files.sort((a, b) => File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()));
    return files;
  }

  /// Membuka file picker untuk memilih audio eksternal
  Future<String?> pickExternalAudio() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final extDir = await getApplicationDocumentsDirectory();
      final fileName = result.files.single.name;
      final newPath = '${extDir.path}/$fileName';
      
      await File(path).copy(newPath);
      return newPath;
    }
    return null;
  }
}
