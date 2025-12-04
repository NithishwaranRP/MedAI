import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import '../../lib/widgets/logo_icon_painter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    final directory = Directory('assets/logo');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final file = File('assets/logo/app_logo.png');
    await file.writeAsBytes(pngBytes);
    print('✅ Logo created at: ${file.path}');
  }
}


