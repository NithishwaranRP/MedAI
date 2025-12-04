import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Custom painter for app logo icon
/// This can be used to generate the app launcher icon
class LogoIconPainter extends CustomPainter {
  final Color? primaryColor;
  final Color? secondaryColor;

  LogoIconPainter({
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.9;

    // Background gradient circle
    final primary = primaryColor ?? const Color(0xFF4CAF50);
    final secondary = secondaryColor ?? const Color(0xFF2E7D32);
    final dark = const Color(0xFF1B5E20);

    final gradient = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [primary, secondary, dark],
        [0.0, 0.5, 1.0],
      );

    canvas.drawCircle(center, radius, gradient);

    // White border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    canvas.drawCircle(center, radius, borderPaint);

    // Draw eco icon (leaf) - simplified version
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final iconSize = radius * 0.6;
    
    // Draw leaf shape using path
    final path = Path();
    
    // Leaf top point
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


