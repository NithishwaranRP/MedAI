import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Script to generate app launcher icon with eco icon
/// Run: dart tools/create_launcher_icon.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🎨 Creating app launcher icon...');
  
  const size = 1024.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Draw background circle with gradient
  final center = Offset(size / 2, size / 2);
  final radius = size / 2 * 0.9;
  
  // Gradient background
  final gradient = Paint()
    ..shader = ui.Gradient.radial(
      center,
      radius,
      [
        const Color(0xFF4CAF50), // Primary green
        const Color(0xFF2E7D32), // Medium green
        const Color(0xFF1B5E20), // Dark green
      ],
      [0.0, 0.5, 1.0],
    );
  
  canvas.drawCircle(center, radius, gradient);
  
  // White border
  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.03;
  
  canvas.drawCircle(center, radius, borderPaint);
  
  // Draw eco icon (leaf) - simplified version
  final iconSize = radius * 0.6;
  final iconPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  
  // Create a path for the leaf shape
  final path = Path();
  
  // Leaf shape (simplified eco icon)
  path.moveTo(center.dx, center.dy - iconSize * 0.4);
  
  // Right curve
  path.quadraticBezierTo(
    center.dx + iconSize * 0.3,
    center.dy - iconSize * 0.1,
    center.dx + iconSize * 0.25,
    center.dy + iconSize * 0.2,
  );
  
  // Bottom right
  path.quadraticBezierTo(
    center.dx + iconSize * 0.1,
    center.dy + iconSize * 0.4,
    center.dx,
    center.dy + iconSize * 0.35,
  );
  
  // Bottom left
  path.quadraticBezierTo(
    center.dx - iconSize * 0.1,
    center.dy + iconSize * 0.4,
    center.dx - iconSize * 0.25,
    center.dy + iconSize * 0.2,
  );
  
  // Left curve
  path.quadraticBezierTo(
    center.dx - iconSize * 0.3,
    center.dy - iconSize * 0.1,
    center.dx,
    center.dy - iconSize * 0.4,
  );
  
  path.close();
  canvas.drawPath(path, iconPaint);
  
  // Draw stem
  final stemPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = iconSize * 0.1
    ..strokeCap = StrokeCap.round;
  
  canvas.drawLine(
    Offset(center.dx, center.dy + iconSize * 0.35),
    Offset(center.dx, center.dy + iconSize * 0.65),
    stemPaint,
  );
  
  // Convert to image
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
    
    print('✅ Launcher icon created successfully!');
    print('📁 Location: ${file.absolute.path}');
    print('');
    print('📱 Next step: Run this to generate all icon sizes:');
    print('   flutter pub run flutter_launcher_icons');
  } else {
    print('❌ Failed to generate icon');
    exit(1);
  }
  
  exit(0);
}


