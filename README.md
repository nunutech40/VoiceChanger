# VoiceChanger 🎙️✨ (AuraVoice)

**VoiceChanger (AuraVoice)** is a high-performance **Content Factory** and **Tech-Flexing** portfolio piece built on modern cross-platform mobile architecture (iOS & Android).

This application is specifically designed with two primary objectives for the **US Market**:
1. **For X (Twitter) & Indie Hackers:** To showcase the raw power of software architecture by bypassing standard OS method channels, connecting a beautiful **Flutter** interface directly to a **C++ computational brain (SoLoud Engine)** via Dart FFI for zero-latency Digital Signal Processing (DSP).
2. **For US Startup Founders:** To demonstrate the ability to build premium, sleek, Apple-esque UI/UX (Glassmorphism, Dark Mode) while maintaining 120fps performance by offloading heavy tasks to background Isolates.

> 🚀 **THE SECRET SAUCE**
> While the UI looks incredibly sleek and minimalist, the engine underneath is pure math. By utilizing *Synchronous FFI*, the UI sliders manipulate C++ float pointers directly in memory. No data queuing, no loading states—just pure, instantaneous execution.

## 🔥 Key Features (The Flex)
*   **Zero-Latency Audio DSP:** Adjusting sliders directly mutates memory on the C++ side without the usual `MethodChannel` overhead.
*   **Premium US-Market Aesthetics:** Sleek `#0D0D0E` dark mode, subtle gradients, and glassmorphism elements targeting modern SaaS and startup design languages.
*   **Clean Architecture (SOLID):** Strictly decoupled Domain, Data, and Presentation layers. Features like File History and Audio Import are orchestrated cleanly via `UseCases`.
*   **Off-Main-Thread Processing:** Heavy FFT calculations (simulated) and file I/O operations are offloaded from the UI thread to guarantee buttery-smooth 120Hz scrolling.
*   **Audio Import & History:** Seamlessly import `.m4a`, `.mp3`, or `.wav` files via native file pickers and maintain an accessible history of recordings.

## Project Documentation
Please refer to the following architectural documents:
*   [PRD (Product Requirements Document)](PRD.md) - Product plans, features, market targeting, and UI specifications.
*   [TRD (Technical Requirements Document)](TRD.md) - Clean Architecture patterns, tech stack, and C++ FFI Bridge anatomy.
*   [EXECUTION PLAN](EXECUTION_PLAN.md) - Step-by-step checklist of the MVP execution.
*   [DSP ENGINE ARCHITECTURE](DSP_ENGINE_ARCHITECTURE.md) - Deep dive into the audio pipeline.
