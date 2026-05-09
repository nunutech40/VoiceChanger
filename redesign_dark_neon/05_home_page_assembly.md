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
