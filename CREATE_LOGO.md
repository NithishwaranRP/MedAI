# Create App Logo - Simple Steps

## Method 1: Screenshot from App (Easiest)

1. Run the app: `flutter run`
2. When splash screen appears, take a screenshot
3. The logo appears as a green circle with white leaf icon
4. Crop the logo to 1024x1024 pixels
5. Save as `assets/logo/app_logo.png`
6. Run: `flutter pub run flutter_launcher_icons`

## Method 2: Use Online Icon Generator

1. Visit: https://www.appicon.co/ or https://icon.kitchen/
2. Create a 1024x1024 image with:
   - Green gradient circle background (#4CAF50 to #1B5E20)
   - White leaf icon (eco/plant symbol) in center
   - White border
3. Download and save as `assets/logo/app_logo.png`
4. Run: `flutter pub run flutter_launcher_icons`

## Method 3: Design Tool

Use any design tool (Photoshop, Figma, Canva, etc.):
- Size: 1024x1024 pixels
- Background: Green gradient circle
- Icon: White eco/leaf symbol
- Border: White circle border
- Save as PNG
- Place in `assets/logo/app_logo.png`

## After Creating Logo:

```bash
# Generate all icon sizes
flutter pub run flutter_launcher_icons

# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

The logo widget code is ready in `lib/widgets/app_logo.dart` - you just need to create the PNG image file!


