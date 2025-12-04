import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Score badge widget showing coins and streak
class ScoreBadge extends StatelessWidget {
  final int coins;
  final int streak;

  const ScoreBadge({
    Key? key,
    required this.coins,
    required this.streak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coins
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                color: AppColors.gold,
                size: isTablet ? 22 : 18,
              ),
              const SizedBox(width: 4),
              Text(
                '$coins',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Streak only shown when > 0 (active streak)
          if (streak > 0) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1,
              height: 20,
              color: Colors.white.withOpacity(0.3),
            ),
            // Streak
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: AppColors.orange,
                  size: isTablet ? 22 : 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '$streak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

