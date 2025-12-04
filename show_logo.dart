import 'package:flutter/material.dart';
import 'lib/widgets/logo_icon_painter.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Creating app logo...');
  
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
    final dir = Directory('assets/logo');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('assets/logo/app_logo.png');
    await file.writeAsBytes(pngBytes);
    print('✅ Logo saved to: ${file.path}');
    print('Now run: flutter pub run flutter_launcher_icons');
  }
  
  exit(0);
}


