# App Logo Setup Guide

## Quick Solution: Generate Logo Image

The app logo widget is already created. To use it as the app launcher icon, follow these steps:

### Option 1: Use the Logo Widget (Recommended)

1. **Create the logo image manually:**
   - Open the app in an emulator/device
   - The logo widget is already integrated in the splash screen
   - Take a screenshot of the logo (it appears on splash screen)
   - Crop it to 1024x1024 pixels
   - Save as `assets/logo/app_logo.png`

2. **Or use an online tool:**
   - Go to https://www.favicon-generator.org/ or similar
   - Upload a screenshot of the logo
   - Download the 1024x1024 version
   - Save as `assets/logo/app_logo.png`

### Option 2: Use the Logo Widget Code

The logo is defined in `lib/widgets/app_logo.dart` and `lib/widgets/logo_icon_painter.dart`.

You can:
1. Run the app
2. Take a screenshot of the splash screen logo
3. Crop to 1024x1024
4. Save as `assets/logo/app_logo.png`

### After Creating the Logo Image:

1. **Generate app icons:**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

2. **Rebuild the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

## Logo Design

The logo features:
- Green gradient circular background (#4CAF50 to #1B5E20)
- White eco leaf icon in the center
- White border around the circle
- Clean, modern design matching the app theme

## Current Status

✅ Logo widget created (`lib/widgets/app_logo.dart`)
✅ Logo painter created (`lib/widgets/logo_icon_painter.dart`)
✅ Logo integrated in UI (splash, home, about screens)
✅ Icon configuration ready (`flutter_launcher_icons.yaml`)
⏳ Need to create `assets/logo/app_logo.png` (1024x1024 PNG)

Once you create the PNG file, run `flutter pub run flutter_launcher_icons` to generate all app icon sizes!


