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

## 3. Fase 3: User Interface & Templates (Tampilan)
*   [ ] Membuat *Home Screen* dengan tombol rekam yang besar dan intuitif.
*   [ ] Membuat *Playback Screen* (muncul setelah rekaman selesai).
*   [ ] Membuat deretan (horizontal scroll) tombol *Templates*.
*   [ ] **Fitur Utama MVP:** Menyediakan 4 template dasar (Normal, Chipmunk, Monster, Robot).
*   [ ] Ketika template ditekan, suara yang sedang diputar akan langsung berubah mengikuti preset template.

## 4. Fase 4: Custom Tuning Page (Manipulasi)
*   [ ] Membuat Halaman "Custom Tune" yang bisa diakses dari tombol di sebelah Template.
*   [ ] Mengirim parameter template yang sedang aktif (misal: `Pitch = 1.8`) ke Halaman Custom Tune, sehingga *slider* langsung berada di angka 1.8 (bukan kembali ke 0).
*   [ ] Menyediakan Slider UI untuk minimal 3 efek:
    *   **Slider Pitch** (Ubah Nada)
    *   **Slider Speed** (Ubah Tempo/Kecepatan)
    *   **Slider Reverb** (Tingkat Gema Ruangan)
*   [ ] Perubahan pada slider langsung merubah parameter `SoLoud` secara sinkron dan real-time.

## 5. Fase 5: Exporting (Simpan)
*   [ ] *Research:* Karena file audio di-play melalui C++ Engine secara *on-the-fly* dengan filter, fitur *Export* membutuhkan rendering filter ke dalam file audio baru (`.wav`). `flutter_soloud` bisa di-setup untuk menangkap output audionya, atau menggunakan package rendering eksternal. (Fitur ini adalah batas akhir MVP untuk memastikan user bisa menyimpan hasil karyanya).
*   [ ] Menyimpan file akhir ke Gallery/File Manager HP.

---
*Catatan:* Animasi grafis/gelombang suara (audio visualizer) diturunkan prioritasnya dari MVP dan akan ditambahkan pada *update* berikutnya agar fokus pengembangan tetap pada performa audio engine.
