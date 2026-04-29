# Technical Requirements Document (TRD): AuraVoice (Clean Architecture Edition)

## 1. Arsitektur Sistem (The Zero-Latency Flex)
Sistem ini membuang pendekatan *MethodChannel* tradisional (yang lambat dan *asynchronous*) dan menggantinya dengan arsitektur **Direct Memory Access (DMA)** tiruan melalui **Synchronous Foreign Function Interface (FFI)**. 

Tujuannya? Untuk dipamerkan (*Tech Flexing*). Arsitektur ini membuktikan bahwa Flutter UI dan Otak C++ (DSP) bisa saling memanipulasi *pointer* memori secara *real-time*, menghasilkan modifikasi gelombang suara (*Pitch/Tempo*) tanpa jeda sama sekali. Selain itu, arsitektur ini memisahkan proses berat (Audio) dan proses kosmetik (Visualizer) menggunakan pola **Isolate-driven UI** agar layar berjalan mulus di 120fps.

## 2. Tech Stack (Spesifikasi Teknologi)
Berikut adalah daftar lengkap teknologi yang digunakan beserta alasan penggunaannya:

### 2.1 Flutter / Dart (Lapisan Antarmuka & Logika Bisnis)
*   **Flutter & Dart:** Digunakan untuk merancang antarmuka bergaya *hacker* yang *over-engineered*.
*   **Clean Architecture:** Memisahkan kode menjadi lapisan `Presentation`, `Domain`, dan `Data`.
*   **Isolate (Dart Concurrency):** Menjalankan kalkulasi *Cinematic Fake Visualizer* di luar *Main Thread*. Tujuannya agar animasi *level meter* yang rumit tidak mengganggu proses rendering UI utama (*Flexing point* untuk diposting di X).
*   **BLoC / Cubit (`flutter_bloc`):** *State Management* utama yang merespons secara reaktif setiap pergeseran *slider*.
*   **Dependency Injection (`get_it`):** Kontainer sentral untuk injeksi otomatis *Repository* dan *UseCase*.
*   **Audio Recording (`record`):** Pustaka untuk menangkap buffer data suara mentah dari mikrofon OS.

### 2.2 Audio Engine (Lapisan DSP & Kecerdasan Pemrosesan)
*   **C++ (SoLoud Engine):** *Engine* audio *open-source* berkinerja tinggi yang memproses manipulasi gelombang audio (DSP) murni secara lokal di dalam memori perangkat.
*   **Dart FFI (Foreign Function Interface):** Penghubung sinkron antara Dart dan biner C++. Berbeda dengan *MethodChannel* yang mengantre pesan (*asynchronous*), FFI mengizinkan Dart memanipulasi *pointer* memori C++ secara seketika (*synchronous*), sangat krusial untuk *audio real-time*.
*   **`flutter_soloud`:** *Package* Flutter yang membungkus *SoLoud engine* dan mengekspos filter audio (*Pitch Shift*, *Time Stretch*, *Echo*) langsung ke lapisan Dart.

## 3. Pembagian Layer (Clean Architecture)

### 3.1 Data Layer (Penanganan C++ Engine)
Di sinilah letak perbatasan antara Dart dan lapisan C++.
*   **Audio Data Source (`AudioNativeDataSource`):** Bertanggung jawab memanggil *method* dari `flutter_soloud`. Fungsi utamanya adalah melakukan *load* file rekaman, menjalankan audio, dan menempelkan ID Filter (*Pitch*, *Reverb*) ke proses *playback*.
*   **Repository Implementation (`AudioRepositoryImpl`):** Menerjemahkan kebutuhan *Domain* (seperti merubah nilai *slider* 0.5) menjadi perintah *Data Source* yang spesifik.

### 3.2 Domain Layer (Core Business Rules)
*   **Entity (`AudioFilterEntity`):** Data kelas murni berisi konfigurasi *template* atau nilai saat ini dari slider (contoh: `pitch: 1.5, reverb: 0.2`).
*   **Use Case (`ApplyVoiceFilterUseCase`):** Fungsi spesifik yang meminta *Repository* untuk mengeksekusi perubahan suara saat *user* berinteraksi dengan antarmuka.

### 3.3 Presentation Layer (UI & State)
*   **BLoC/Cubit (`VoiceTunerCubit`):** Mengelola State (menyimpan angka *slider* saat ini dan *template* yang aktif).
*   **UI (Screens):** Murni menempel ke *state* Cubit. Saat pengguna menggeser slider, UI langsung mengirim nilai baru ke Cubit ➡️ UseCase ➡️ Engine.

## 4. Flowchart Sistem

### 4.1 Flowchart Interaksi UI ke Audio Engine
Bagian ini menggambarkan perjalanan data seketika (*real-time*) saat pengguna menggeser parameter *tuning*.

```mermaid
graph TD
    A[UI Flutter: Geser Slider Pitch] --> B[VoiceTunerCubit: Update State nilai 1.8]
    B --> C[[Domain: ApplyVoiceFilterUseCase]]
    C --> D[[Data: AudioRepository]]
    D --> E[Data Source: Panggil SoLoud.setFilterParameter]
    
    subgraph Engine Bridge
    E --> F[Dart FFI: Kirim float ke pointer C++]
    F --> G((C++ SoLoud Engine))
    G --> H[Modifikasi Buffer Audio Aktif]
    end
    
    H --> I[Speaker: Suara Pitch Langsung Berubah]
```

### 4.2 Sequence Diagram Anatomi Komunikasi FFI (Kenapa MethodChannel Itu Sampah Untuk Audio)
Bagian ini adalah argumen utama untuk *Tech Flexing*. FFI menendang keluar antrean OS dan membiarkan Dart langsung menusuk ruang memori C++ secara **Synchronous**.

```mermaid
sequenceDiagram
    autonumber
    participant UI as 💙 Flutter (Main Thread)
    participant FFI as ⚡ Dart FFI (Memory Pointer)
    participant CPP as ⚙️ C++ (SoLoud DSP)

    Note over UI: UI dikunci di 120fps
    UI->>FFI: setFilterParam(filterId, pitchId, 0.5)
    
    Note over FFI: SYNCHRONOUS MEMORY ACCESS <br> (Bypass OS Queue)
    FFI->>CPP: Tulis/Timpa nilai 0.5 langsung ke alamat memory C++
    CPP->>CPP: Kalkulasi ulang Buffer secara matematis
    CPP-->>FFI: Pointer tersimpan
    
    FFI-->>UI: Lanjut eksekusi UI (Latensi < 1ms)
    Note over CPP: Audio Thread (Terpisah) melempar buffer termodifikasi ke Speaker
```

## 5. Struktur Direktori Proyek
*(Struktur ditekankan pada pemisahan layer Clean Architecture)*

```text
VoiceChanger/
│
├── lib/
│   ├── injection.dart                # Dependency Injection (Setup GetIt)
│   ├── main.dart
│   │
│   ├── data/
│   │   ├── datasources/audio_native_datasource.dart # (FFI/SoLoud Caller)
│   │   └── repositories/audio_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/audio_filter_entity.dart
│   │   ├── repositories/i_audio_repository.dart
│   │   └── usecases/apply_voice_filter_usecase.dart
│   │
│   └── presentation/
│       ├── bloc/voice_tuner_cubit.dart
│       ├── pages/home_record_page.dart
│       ├── pages/playback_template_page.dart
│       ├── pages/custom_tuner_page.dart
│       └── widgets/sliders/
│
├── PRD.md              
├── TRD.md              
├── MVP.md              
└── README.md
```
