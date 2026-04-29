# VoiceChanger 🎙️✨ (AuraVoice)

# VoiceChanger 🎙️✨ (AuraVoice)

**VoiceChanger (AuraVoice)** bukanlah sekadar aplikasi pengubah suara. Ini adalah **Pabrik Konten (Content Factory)** dan sarana **Tech-Flexing** yang dibangun di atas fondasi *mobile cross-platform* (iOS & Android).

Aplikasi ini didesain secara khusus dengan dua tujuan utama:
1.  **Untuk TikTok:** Menyajikan *UI/UX* yang *over-engineered* bergaya *hacker* audio untuk menciptakan *gimmick* visual yang kuat di depan kamera.
2.  **Untuk X (Twitter):** Memamerkan kebrutalan arsitektur perangkat lunak dengan menyambungkan antarmuka **Flutter** langsung ke otak komputasi **C++ (SoLoud Engine)** melalui Dart FFI demi mencapai latensi nol (*zero-latency DSP*).

> 🤫 **SSSTTT... RAHASIA!**
> Meskipun aplikasi ini terlihat seperti alat peretas frekuensi rahasia, *engine* utamanya secara murni hanya mengeksekusi operasi matematika terhadap gelombang suara (*Pitch Shifting* dan *Time Stretching*). Namun, arsitektur *Synchronous FFI* yang kami bangun membuat manipulasi ini merespons seketika tanpa *overhead* yang biasa ditemukan pada *MethodChannel*!

## 🔥 Fitur Utama (The Flex)
*   **Zero-Latency Audio DSP:** Menggeser *slider* di UI langsung memanipulasi *pointer float* di memori C++. Tidak ada antrean data, tidak ada proses *loading*, murni *real-time*.
*   **Cinematic Audio Gimmick:** Dilengkapi dengan visualisasi gelombang suara (*fake visualizer*) yang dirender secara terpisah dari *Main Thread* agar terlihat rumit dan canggih di konten video.
*   **Synchronous FFI Bridge:** Pembuktian konsep bahwa Flutter bisa berjalan secepat aplikasi *Native* jika integrasinya mem- *bypass* arsitektur standar jembatan komunikasi OS.
*   **Template Absurd:** Preset "sulap" suara instan (Tupai, Monster, Robot) yang siap dipakai untuk membuat *meme* atau video lucu.

## Dokumen Proyek
Silakan baca dokumen perencanaan arsitektur di bawah ini:
*   [PRD (Product Requirements Document)](PRD.md) - Rencana produk, fitur, tipe-tipe template, dan target audiens.
*   [TRD (Technical Requirements Document)](TRD.md) - Arsitektur sistem (*Clean Architecture*), spesifikasi *tech stack*, dan anatomi *C++ FFI Bridge*.
*   [EXECUTION PLAN](EXECUTION_PLAN.md) - Rencana pengerjaan *checklist step-by-step* eksekusi MVP.
