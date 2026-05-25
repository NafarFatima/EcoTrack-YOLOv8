# EcoTrack Flutter App

A complete Flutter implementation of the EcoTrack recycling app.

## Screens Implemented

1. **Splash Screen** — Logo animation, auto-advances after 2s
2. **Onboarding** — Recycling symbol hero, dot indicators, skip button
3. **Auth Screen** — Login/Sign Up tabs, social login buttons
4. **Home Screen** — Greeting, weekly goal progress, stats cards, missions, article
5. **Add Item Screen** — Category grid (Plastic/Paper/Glass/Metal), upload zone, form, success toast
6. **History Screen** — Toggle between History list and Categories view
7. **Rewards Screen** — Points hero card, achievements grid, leaderboard
8. **Profile Screen** — User info, eco points card, settings with dark mode toggle, logout

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── theme/
│   └── app_theme.dart         # Colors, text styles, decorations
└── screens/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── auth_screen.dart
    ├── main_shell.dart        # Bottom nav shell
    ├── home_screen.dart
    ├── add_screen.dart
    ├── history_screen.dart
    ├── rewards_screen.dart
    └── profile_screen.dart
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Custom Fonts (Optional)

To use DM Sans (matching the design), download from Google Fonts and:
1. Add font files to `assets/fonts/`
2. Uncomment the fonts section in `pubspec.yaml`

## Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#2D6A2D` | Main green, buttons, accents |
| `primaryDark` | `#1A3D1A` | Headings, dark elements |
| `primaryLight` | `#3D8B3D` | Positive changes, highlights |
| `background` | `#F5F5E8` | App background |
| `backgroundLight` | `#F0F4E4` | Card backgrounds, input fills |
