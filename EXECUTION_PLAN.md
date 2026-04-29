# Execution Plan: Voice Changer App

Dokumen ini berisi *checklist* eksekusi teknis *step-by-step* untuk mencapai versi pertama (v1.0 / MVP) dari aplikasi Voice Changer.

## 1. Fase 1: Setup Audio Engine & Recording (Fondasi)
*   [ ] Inisialisasi *project* Flutter baru.
*   [ ] Instalasi dan setup `flutter_soloud` untuk C++ Audio Engine (termasuk konfigurasi CMake di Android dan Podfile di iOS).
*   [ ] Instalasi package perekam suara (misal: `record` atau `audio_waveforms`).
*   [ ] Implementasi fitur meminta *permission* Microphone dan Storage dari sistem operasi.
*   [ ] Berhasil merekam suara maksimal 60 detik dan menyimpannya sebagai file temporary.

## 2. Fase 2: Core Engine & Playback (Playback & Filter)
*   [ ] Menghubungkan file rekaman ke engine `SoLoud`.
*   [ ] Implementasi fungsi Play, Pause, dan Stop standar.
*   [ ] Mengaktifkan sistem Filter di `SoLoud` (khususnya *Pitch Shift* dan *Time Stretch*).
*   [ ] Memastikan tidak ada *memory leak* saat inisialisasi filter berulang-ulang.

## 3. Fase 3: User Interface & Templates (The Hacker Aesthetic)
*   [ ] Membuat *Home Screen* bergaya *Cyberpunk / Over-engineered* dengan tombol rekam yang futuristik.
*   [ ] Membuat *Playback Screen* (muncul setelah rekaman selesai).
*   [ ] Membuat deretan tombol *Templates* (Tupai, Monster, Robot, Gua Hantu).
*   [ ] **Fitur Utama Konten:** Ketika template ditekan, suara yang sedang diputar akan langsung berubah mengikuti preset template, disertai efek visual UI berkedip ala layar *hacker*.

## 4. Fase 4: Custom Tuning Page & Isolate Visualizer (The Flex)
*   [ ] Membuat Halaman "Voice Modulator" dengan tema UI *Dark Mode* dan *Neon Sliders*.
*   [ ] **Sinkronisasi Otomatis:** Mengirim parameter template yang sedang aktif ke halaman Modulator, sehingga posisi *Neon Slider* langsung menyesuaikan angka *preset* (tidak kembali ke 0).
*   [ ] Menyediakan *Neon Slider UI* untuk minimal 3 efek (Pitch, Speed, Reverb).
*   [ ] Perubahan pada slider langsung merubah parameter pointer memori C++ (`SoLoud`) secara *synchronous*.
*   [ ] **Cinematic Audio Gimmick:** Mengerjakan animasi *Fake Visualizer* (Gelombang suara palsu / Level Meter) yang dijalankan melalui **Dart Isolate** agar *Main Thread* tidak *lag* (sebagai bahan *flexing* arsitektur di X/Twitter).

## 5. Fase 5: Exporting (Simpan)
*   [ ] *Research & Implementasi:* Merender filter audio menjadi file audio baru (`.wav`/`.m4a`) menggunakan kapabilitas tangkapan output `flutter_soloud` atau *package* eksternal.
*   [ ] Menyimpan file akhir ke Gallery/File Manager HP untuk dibagikan ke TikTok.

---
*Catatan:* Penggunaan *Dart Isolate* untuk *Fake Visualizer* dan elemen UI *Cyberpunk* menjadi prioritas utama untuk menonjolkan aspek *performance* dan *aesthetic* dalam MVP.
