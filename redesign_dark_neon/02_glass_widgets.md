# Step 2: Implement Base Glass Widgets

## Objective
Create the core "Glassmorphism" UI components that will be used throughout the app (cards, containers, navigation bars).

## Specifications
- **Widget Name**: `NeonGlassCard`
- **Core Components**:
  - `BackdropFilter` with `ImageFilter.blur(sigmaX: 25, sigmaY: 25)`.
  - `Container` with a semi-transparent background (e.g., `Colors.white.withOpacity(0.05)`).
  - `BoxBorder` with a thin, low-opacity gradient to simulate light catching the edge.
- **Skill Usage**: Use `flutter-add-widget-preview` to visualize the glass effect against a dark gradient background.

## Execution
1. Create `lib/ui/widgets/common/neon_glass_card.dart`.
2. Implement the widget using `ClipRRect` and `BackdropFilter`.
3. Add parameters for `borderRadius`, `padding`, and `child`.

## Verification
- Use `npx skills add flutter-add-widget-preview` (if not already present) to create a preview file.
- Verify the transparency and blur intensity look "premium" and "clean".
