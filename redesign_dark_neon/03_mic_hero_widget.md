# Step 3: Redesign the Neon Mic Hero Button

## Objective
Transform the current recorder button into a high-impact, audio-reactive hero element with neon glows and smooth animations.

## Specifications
- **Style**: Floating orb with a glowing aura.
- **Neon Pulse**: Use `AnimatedBuilder` or `AnimatedContainer` to create a breathing glow effect using `BoxShadow` with high spread/blur.
- **Icons**: Clean, minimalist mic icon (Cupertino or custom SVG).
- **Interactions**: Subtle scale-up on tap/hold.

## Execution
1. Create `lib/ui/widgets/home/neon_mic_button.dart`.
2. Wrap the core button in a `Stack` to layered multiple `BoxShadow` layers for the "Neon Glow" effect.
3. Integrate the pulsing animation logic.

## Verification
- Create a widget preview to test the animation smoothness.
- Ensure the glow doesn't look "pixelated" (use multiple layered shadows for smoothness).

## Current Implementation Notes (May 9, 2026)
- Implemented in `lib/ui/widgets/home/neon_mic_button.dart`.
- The mic is now the Home screen hero interaction, not just a static button.
- Uses `AnimationController`, `AnimatedBuilder`, and layered `Stack`/`BoxShadow` effects.
- Idle state shows a large white mic core with blue/purple neon ring.
- Press state adds:
  - subtle compression
  - ripple ring
  - boosted glow
  - temporary energy bars
- Recording state keeps the mic visually alive with breathing glow and active bars.
- Icons are Material icons for runtime consistency on the current Flutter build.

## Lessons Learned
- A reference-image-based redesign from AI tools produced the right concept but weak implementation details.
- The mic needed interaction polish because it is the first thing users tap and the most important element for a short X demo video.
- Overly decorative effects should be avoided unless they improve clarity or demo value.
