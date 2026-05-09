# Step 4: Redesign Recording List Tiles

## Objective
Convert the current flat recording tiles into elegant glass cards that follow the "Cupertino Clean & Bright" depth principles but in a "Dark Neon" context.

## Specifications
- **Container**: Use the `NeonGlassCard` created in Step 2.
- **Typography**: Use "Inter" or "Outfit" font (if available) or standard Cupertino font. 
- **Layout**: 
  - Clearer hierarchy: Title (white), Date/Time (grey/blueish).
  - Trailing menu icon should be a subtle ghost button.
  - Leading play icon should have a small neon accent glow.

## Execution
1. Update `lib/ui/widgets/home/recording_list_tile.dart`.
2. Replace the old `ListTile` with a custom `NeonGlassCard` implementation for better control over the layout and transparency.

## Verification
- Test responsiveness: Ensure the tile looks good on different screen widths.
- Verify the "Glass" effect doesn't make the text unreadable (use appropriate text shadows if needed).
