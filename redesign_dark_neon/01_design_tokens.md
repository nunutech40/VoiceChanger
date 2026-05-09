# Step 1: Define Dark Neon Design Tokens

## Objective
Create a central theme file for the "Dark Neon Glassmorphism" aesthetic to ensure consistency across all redesigned widgets.

## Style Specifications
- **Background**: Deep midnight black/navy (#0A0C14) with subtle radial gradients.
- **Neon Glows**: 
  - Primary: Cyan/Blue (#4D9FFF)
  - Secondary: Purple/Magenta (#BD5CFF)
- **Glass Effect**:
  - Opacity: 10% - 15%
  - Blur: 20.0 - 30.0 (BackdropFilter)
  - Border: Subtle gradient border (1px) with 20% opacity.

## Execution
1. Create or update `lib/ui/theme/app_colors.dart`.
2. Define `static const` colors for:
   - `backgroundDeep`
   - `neonPrimary`, `neonSecondary`
   - `glassSurface`, `glassBorder`
3. Create `lib/ui/theme/app_gradients.dart` for the background and neon pulse gradients.

## Verification
- Ensure colors match the "Cyber Gradient" and "Neon Glow" aesthetic.
- Run `flutter analyze` to check for syntax errors.
