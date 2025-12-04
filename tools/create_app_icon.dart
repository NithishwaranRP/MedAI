import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import '../lib/widgets/logo_icon_painter.dart';

/// Simple script to create app icon
/// This creates a 1024x1024 PNG image for the app launcher icon

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const size = 1024.0;
  
  // Create a render object
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Create the logo painter
  final painter = LogoIconPainter();
  
  // Paint the logo
  painter.paint(canvas, Size(size, size));
  
  // Convert to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
  if (byteData != null) {
    final pngBytes = byteData.buffer.asUint8List();
    
    // Ensure directory exists
    final directory = Directory('assets/logo');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    // Save the image
    final file = File('assets/logo/app_logo.png');
    await file.writeAsBytes(pngBytes);
    
    print('✅ App logo created successfully!');
    print('📁 Location: ${file.absolute.path}');
    print('');
    print('Next steps:');
    print('1. Run: flutter pub run flutter_launcher_icons');
    print('2. This will generate all required icon sizes');
    print('3. Rebuild your app');
  } else {
    print('❌ Failed to generate logo image');
  }
}


