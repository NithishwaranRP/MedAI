import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Script to generate app logo as PNG image
/// Run with: flutter run -d windows tools/generate_logo.dart
/// Or use: dart tools/generate_logo.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the logo widget
  final logoWidget = _LogoPainter();

  // Create a picture recorder
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Set size (1024x1024 for app icon)
  const size = 1024.0;
  canvas.scale(size / 200); // Scale to fit

  // Paint the logo
  logoWidget.paint(canvas, Size(size, size));

  // Convert to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Save to file
  final file = File('assets/logo/app_logo.png');
  await file.create(recursive: true);
  await file.writeAsBytes(pngBytes);

  print('Logo generated successfully at: ${file.path}');
  print('Now run: flutter pub run flutter_launcher_icons');
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.9;

    // Background gradient circle
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
      ..strokeWidth = size.width * 0.03;

    canvas.drawCircle(center, radius, borderPaint);

    // Draw eco icon (leaf)
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw a simple leaf shape
    final path = Path();
    final iconSize = radius * 0.6;
    
    // Leaf shape (simplified)
    path.moveTo(center.dx, center.dy - iconSize * 0.3);
    path.quadraticBezierTo(
      center.dx + iconSize * 0.4,
      center.dy - iconSize * 0.1,
      center.dx + iconSize * 0.2,
      center.dy + iconSize * 0.3,
    );
    path.quadraticBezierTo(
      center.dx,
      center.dy + iconSize * 0.5,
      center.dx - iconSize * 0.2,
      center.dy + iconSize * 0.3,
    );
    path.quadraticBezierTo(
      center.dx - iconSize * 0.4,
      center.dy - iconSize * 0.1,
      center.dx,
      center.dy - iconSize * 0.3,
    );
    path.close();

    canvas.drawPath(path, iconPaint);

    // Draw stem
    final stemPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = iconSize * 0.08
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy + iconSize * 0.3),
      Offset(center.dx, center.dy + iconSize * 0.6),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


