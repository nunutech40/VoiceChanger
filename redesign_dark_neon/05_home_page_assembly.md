# Step 5: Final Home Page Assembly

## Objective
Combine all the new components into the final "Dark Neon Glassmorphism" Home Page.

## Tasks
- **Background**: Apply the deep black radial gradient from Step 1.
- **Header**: Refine the "AuraVoice" logo with a premium neon glow.
- **Bottom Navigation**: Redesign the navigation bar to be a floating glass element at the bottom of the screen.
- **Layout**: Ensure proper spacing (fewer borders, more contrast, strong hierarchy).

## Execution
1. Update `lib/ui/pages/home_page.dart`.
2. Wrap the entire `Scaffold` background in a `Stack` to allow for floating background glows (Blobs).
3. Integrate `NeonMicButton`, `NeonGlassCard`, and the redesigned list.

## Final Verification
- Run the full app on an iOS simulator/device to check the Impeller rendering performance.
- Ensure the "Emotional / Creator Energy" vibe is achieved.

## Current Implementation Notes (May 9, 2026)
- Implemented in `lib/presentation/pages/home_record_page.dart`.
- The original AI-generated redesign was corrected into a custom Home screen layout.
- The screen now uses:
  - full-screen dark neon background
  - custom `AuraVoice` header
  - premium mic hero component
  - animated `Tap to Record` prompt
  - glass recent recordings panel
  - floating glass bottom navigation
  - responsive sizing through `LayoutBuilder`
- The recent recordings list is scrollable even when only showing the latest three items, because smaller iPhones can clip the lower content.
- Bottom navigation actions are intentionally conservative:
  - `Home` stays on the current screen
  - `Tuner` opens the latest recording if one exists
  - if no recording exists, the user is prompted to record/import audio first
  - `Settings` currently shows a placeholder snackbar because there is no real Settings page yet
- A liquid-glass tab animation was attempted and removed because it looked visually wrong. The current nav keeps the safer glass blur + active state approach.

## Current Scope
- Finished: Home screen redesign pass.
- Not finished:
  - Tuner screen redesign
  - Advanced Tuner redesign
  - Settings screen implementation
  - full visual consistency across all pages
  - final demo polish for X/Twitter screen recording

## Verification Performed
- `fvm dart format` on changed files.
- `fvm flutter test` passed.
- `fvm flutter analyze` still reports older issues outside this Home redesign work.
