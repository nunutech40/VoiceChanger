# Cupertino "Clean & Bright" Redesign Plan (US Market)

Berdasarkan referensi desain UI *Calorie Tracker* yang dikirimkan, pasar US saat ini sangat menggemari desain yang **Clean, Minimalist, Bright**, dan **Cupertino-inspired** (khas iOS Apple). Desain bergaya AI yang serba gelap (*Dark Mode + Neon*) memang mulai terasa *niche*, sedangkan *Clean Design* memberikan kesan **Premium, Terpercaya, dan Bermanfaat (Meaningful)**.

## Core Design System (Visual Tokens)
*   **Background:** Pure White (`#FFFFFF`) atau Light Off-White (`#F8F9FA`) untuk memberi kesan luas dan bersih.
*   **Primary Accent:** Soft Bright Blue (`#4A90E2` atau `#3B82F6`) mirip dengan warna utama pada referensi gambar.
*   **Text Colors:** Hitam pekat (`#1A1A1C`) untuk *Heading*, dan Abu-abu lembut (`#8E8E93`) untuk *Subtitle/Hint*.
*   **Shadows:** Sangat halus, tebarannya luas (*large blur radius*), dan opasitasnya rendah (contoh: `Color(0x0A000000)`).
*   **Shapes:** Membulat (*Rounded Corners* khas iOS, radius `16px` hingga `24px`).

## Execution Plan (Langkah Eksekusi)

Kita akan mengeksekusi perombakan ini secara bertahap agar aman dan rapi:

### 📱 Step 1: Global Theme & Core App (`main.dart`)
*   Mengubah `ThemeData` dari *Dark* ke *Light*.
*   Menghapus *background* hitam, menggantinya dengan warna terang.
*   Menyiapkan palet warna global (Primary Blue & Surface White).

### 🎙️ Step 2: Home Record Page (`home_record_page.dart`)
*   **App Bar:** Menggunakan gaya iOS berukuran besar (*Large Title*) dengan warna teks hitam pekat.
*   **Record Button:** Mengubah gradien merah/ungu menjadi desain tombol yang bersih. Misalnya, tombol putih besar dengan bayangan biru lembut yang membesar (*pulsing*) saat direkam.
*   **History List:** Menghapus desain kotak hitam (*bottom sheet*), menggantinya dengan daftar *Card* berwarna putih solid yang melayang lembut di atas *background* abu-abu sangat muda. Setiap *item* akan memiliki *icon* yang memiliki *meaning* (misal: *icon folder* biru pucat).

### 🎛️ Step 3: Playback & Template Page (`playback_template_page.dart`)
*   **Header File Info:** Berubah menjadi *Card* putih bersih dengan teks hitam.
*   **Voice Presets:** Tidak lagi memakai ikon neon, tapi menggunakan sistem tombol *Segmented Control* khas iOS atau *Pill Buttons* dengan latar belakang biru muda saat aktif.
*   **Visualizer:** Mengganti warna gelombang menjadi kombinasi biru terang dan abu-abu.
*   **Action Buttons (Play/Download):** Desain membulat sempurna dengan warna solid *Primary Blue* khas Apple.

### 🎚️ Step 4: Custom Tuner Page (`custom_tuner_page.dart`)
*   **Sliders:** Mengubah warna lintasan *slider* menjadi abu-abu terang, dan garis aktifnya menjadi biru. Knob (pegangan) akan diubah menjadi warna putih solid dengan bayangan khas `CupertinoSlider`.
*   **Layout:** Disusun dalam blok-blok kotak putih bersudut lengkung khas *Settings* di iOS.

---
*Proses akan dieksekusi satu per satu. Fokus kita sekarang adalah memastikan fondasinya bersih dan rapi!*
