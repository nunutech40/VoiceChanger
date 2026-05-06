abstract class IAudioRepository {
  /// Menginisialisasi C++ Audio Engine (SoLoud).
  /// Wajib dipanggil saat aplikasi pertama kali dibuka.
  Future<void> initEngine();

  /// Membuang engine dari memori jika aplikasi ditutup.
  Future<void> disposeEngine();

  /// Meminta izin Microphone dan mulai merekam suara.
  /// Akan otomatis berhenti jika durasi mencapai batas maksimal.
  Future<void> startRecording();

  /// Menghentikan rekaman secara manual dan mengembalikan lokasi file (path).
  /// Path ini nantinya akan diload oleh SoLoud untuk dimainkan.
  Future<String?> stopRecording();

  /// Memutar file audio yang sudah direkam
  Future<void> playAudio(String path);

  /// Menghentikan pemutaran audio
  Future<void> stopAudio();

  /// Mengubah pitch dan speed suara menggunakan DSP C++ FFI
  void applyPitchAndSpeed(double pitch, double speed);

  /// Menyimpan hasil audio ke memori perangkat
  Future<String> exportAudio(String sourcePath, double pitch, double speed);

  /// Mengambil daftar path rekaman audio (history)
  Future<List<String>> getAudioHistory();

  /// Membuka file picker untuk import audio eksternal
  Future<String?> pickExternalAudio();

  /// Menghapus file audio berdasarkan path
  Future<void> deleteAudio(String path);
}
