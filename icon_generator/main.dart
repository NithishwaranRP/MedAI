import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import '../lib/widgets/logo_icon_painter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🎨 Generating app logo...');
  
  try {
    const size = 1024.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final painter = LogoIconPainter();
    painter.paint(canvas, Size(size, size));
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      
      // Create directory
      final directory = Directory('assets/logo');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      // Save file
      final file = File('assets/logo/app_logo.png');
      await file.writeAsBytes(pngBytes);
      
      print('✅ Logo generated successfully!');
      print('📁 Location: ${file.absolute.path}');
      print('');
      print('📱 Next: Run this to generate app icons:');
      print('   flutter pub run flutter_launcher_icons');
    } else {
      print('❌ Failed to convert image to bytes');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
  
  exit(0);
}


