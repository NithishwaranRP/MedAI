import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// App Logo Widget - Can be used throughout the app
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    Key? key,
    this.size = 80,
    this.showText = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primaryGreen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                logoColor,
                logoColor.withOpacity(0.8),
                AppColors.mediumGreen,
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: size * 0.05,
            ),
            boxShadow: [
              BoxShadow(
                color: logoColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.eco,
              size: size * 0.6,
              color: Colors.white,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'Med AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

/// Simple Logo Icon (for AppBar, etc.)
class AppLogoIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogoIcon({
    Key? key,
    this.size = 32,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primaryGreen;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            logoColor,
            AppColors.mediumGreen,
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.eco,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}

