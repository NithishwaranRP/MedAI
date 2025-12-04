import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../utils/app_colors.dart';

/// Result screen showing quiz performance
class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int coinsEarned;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.coinsEarned,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  double get _percentage => (widget.score / widget.totalQuestions) * 100;

  String get _performanceMessage {
    if (_percentage >= 90) {
      return 'Outstanding! 🌟';
    } else if (_percentage >= 70) {
      return 'Great Job! 🎉';
    } else if (_percentage >= 50) {
      return 'Good Effort! 👍';
    } else {
      return 'Keep Learning! 📚';
    }
  }

  Color get _performanceColor {
    if (_percentage >= 90) {
      return AppColors.gold;
    } else if (_percentage >= 70) {
      return AppColors.primaryGreen;
    } else if (_percentage >= 50) {
      return AppColors.orange;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 40 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Trophy Icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _performanceColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _performanceColor,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: isTablet ? 80 : 64,
                      color: _performanceColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Performance Message
                  Text(
                    _performanceMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Score Display
                  Container(
                    padding: EdgeInsets.all(isTablet ? 40 : 30),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _performanceColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${widget.score}/${widget.totalQuestions}',
                          style: TextStyle(
                            color: _performanceColor,
                            fontSize: isTablet ? 48 : 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Correct Answers',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 20 : 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: _performanceColor,
                            fontSize: isTablet ? 36 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.monetization_on,
                          label: 'Coins Earned',
                          value: '${widget.coinsEarned}',
                          color: AppColors.gold,
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.percent,
                          label: 'Accuracy',
                          value: '${_percentage.toStringAsFixed(0)}%',
                          color: AppColors.primaryGreen,
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 60 : 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 60 : 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 32 : 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



