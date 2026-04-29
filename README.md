# VoiceChanger 🎙️✨ (AuraVoice)

**VoiceChanger (AuraVoice)** adalah aplikasi *mobile cross-platform* (iOS & Android) yang dirancang untuk merekam suara dan memanipulasinya menggunakan algoritma *Digital Signal Processing* (DSP) secara *real-time*.

Aplikasi ini didesain sebagai *showcase* portofolio *Mobile Development*, memadukan antarmuka **Flutter** yang interaktif dengan otak komputasi audio tingkat rendah berbasis **C++ (SoLoud Engine)** melalui Dart FFI.

> 🤫 **SSSTTT... RAHASIA!**
> Meskipun aplikasi ini menjanjikan template suara "Monster" atau "Tupai", *engine* utama di lapisan C++ secara murni hanya melakukan operasi matematika terhadap gelombang suara (*Pitch Shifting* dan *Time Stretching*). Manipulasi ini berjalan secara *synchronous* tanpa *overhead* sehingga suara merespons seketika (*zero latency*) setiap kali *slider* digeser!

## Fitur Utama
*   **Real-time Audio Modulation:** Geser *slider* dan dengar perubahan nada/tempo suara secara instan tanpa proses *loading*.
*   **Template Presets:** Pilihan "sulap" suara instan seperti Tupai, Monster, Robot, dan Gua Hantu.
*   **C++ Engine Bridge:** UI berjalan mulus di Flutter, sementara komputasi audio yang berat dieksekusi oleh mesin C++ (`flutter_soloud`) via Dart FFI.
*   **Custom Tuning Page:** Halaman kontrol ala teknisi audio (*Voice Modulator*) untuk *fine-tuning* parameter *Pitch*, *Speed*, *Reverb*, dan *Echo*.

## Dokumen Proyek
Silakan baca dokumen perencanaan arsitektur di bawah ini:
*   [PRD (Product Requirements Document)](PRD.md) - Rencana produk, fitur, tipe-tipe template, dan target audiens.
*   [TRD (Technical Requirements Document)](TRD.md) - Arsitektur sistem (*Clean Architecture*), spesifikasi *tech stack*, dan anatomi *C++ FFI Bridge*.
*   [EXECUTION PLAN](EXECUTION_PLAN.md) - Rencana pengerjaan *checklist step-by-step* eksekusi MVP.
