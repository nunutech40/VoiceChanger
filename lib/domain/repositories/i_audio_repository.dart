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
}
