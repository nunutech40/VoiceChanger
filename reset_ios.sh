#!/bin/bash
# ============================================================
# VoiceChanger iOS Reset Script
# Jalankan script ini setiap kali build iOS bermasalah:
#   - Pod install gagal
#   - DerivedData korup
#   - Xcode tidak detect plugin baru
#   - Error "module not found" atau "framework not found"
#
# Usage:
#   chmod +x reset_ios.sh   (jalankan sekali untuk izinkan eksekusi)
#   ./reset_ios.sh
# ============================================================

set -e  # Berhenti otomatis jika ada command yang gagal
export LANG=en_US.UTF-8

PROJECT_NAME="VoiceChanger"

echo ""
echo "============================================================"
echo "  🔄 iOS Build Reset — $PROJECT_NAME"
echo "============================================================"
echo ""

# [1/6] Flutter Clean
echo "🧹 [1/6] Flutter clean (hapus build cache Dart & Flutter)..."
fvm flutter clean
echo "✅ Done."
echo ""

# [2/6] Flutter Pub Get
echo "📦 [2/6] Flutter pub get (restore semua dependencies)..."
fvm flutter pub get
echo "✅ Done."
echo ""

# [3/6] Hapus Artifacts CocoaPods lama
echo "🗑️  [3/6] Hapus artifacts CocoaPods lama..."
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/Runner.xcworkspace
echo "✅ Pods, Podfile.lock, dan xcworkspace dihapus."
echo ""

# [4/6] Alihkan DerivedData ke folder project (biar gak bentrok dengan VS Code)
# Masalah: VS Code (Dart Analysis Server) dan Xcode berebut akses ke
# ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex
# Akibatnya: Xcode error "unable to rename temporary .pcm.tmp"
#
# Solusi: Set DerivedData Xcode ke folder di dalam project sendiri,
# jadi gak bentrok dengan system default yang diakses VS Code.
echo "🗄️  [4/6] Alihkan DerivedData Xcode ke folder project..."

# Tutup Xcode dulu
if pgrep -x "Xcode" > /dev/null; then
  echo "   → Menutup Xcode..."
  killall Xcode 2>/dev/null || true
fi

# Matikan Xcode background services
pkill -f "XCBBuildService" 2>/dev/null || true
pkill -f "sourcekit-lsp" 2>/dev/null || true
pkill -f "swift-frontend" 2>/dev/null || true
pkill -f "com.apple.dt.SKAgent" 2>/dev/null || true

sleep 1

# Set DerivedData lokasi ke folder project
# Xcode akan baca setting ini dari UserDefaults
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
XCODE_DD="$PROJECT_DIR/.ios_derived_data"

# Buat folder DerivedData di project
mkdir -p "$XCODE_DD"

# Set Xcode DerivedData path via UserDefaults
# Ini bikin Xcode pake folder .ios_derived_data di project, bukan ~/Library/...
defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation "$XCODE_DD"

# Bersihin DerivedData lama di system default (biar gak numpuk)
rm -rf ~/Library/Developer/Xcode/DerivedData 2>/dev/null || true

echo "✅ DerivedData Xcode dialihkan ke: $XCODE_DD"
echo "   (VS Code & Dart Analysis Server gak akan ganggu lagi)"
echo ""

# [5/6] Pod Install Ulang
echo "🔧 [5/6] Pod install ulang..."
cd ios
pod install --repo-update
cd ..
echo "✅ Pod install selesai."
echo ""

# [6/6] Selesai — Buka Xcode otomatis
echo "============================================================"
echo "🚀 [6/6] Reset selesai!"
echo ""
echo "   Membuka Runner.xcworkspace di Xcode..."
open ios/Runner.xcworkspace
echo ""
echo "   Setelah Xcode terbuka, pilih device dan tekan ▶ Run."
echo "   Atau jalankan: fvm flutter run"
echo "============================================================"
echo ""
