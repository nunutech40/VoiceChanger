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
