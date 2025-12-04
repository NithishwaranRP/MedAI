import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'quiz_screen.dart';
import 'about_screen.dart';
import '../widgets/score_badge.dart';
import '../widgets/app_logo.dart';
import '../utils/app_colors.dart';

/// Home screen with Chat and Quiz mode options
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 0;
  int _streak = 0;
  bool _hasBronze = false;
  bool _hasSilver = false;
  bool _hasGold = false;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('coins') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
      _hasBronze = prefs.getBool('achievement_bronze') ?? false;
      _hasSilver = prefs.getBool('achievement_silver') ?? false;
      _hasGold = prefs.getBool('achievement_gold') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Row(
          children: [
            const AppLogoIcon(size: 28, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isTablet 
                    ? 'AI Medicinal Plants - Home' 
                    : 'AI Medicinal Plants',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                // Show score popup
                _showScoreDialog();
              },
              child: ScoreBadge(coins: _coins, streak: _streak),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.scaffoldBackground,
              AppColors.mediumGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 40 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section
                Container(
                  padding: EdgeInsets.all(isTablet ? 30 : 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AppLogo(
                        size: 60,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome! 🌱',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 32 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose your learning mode',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 18 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Chat Mode Card
                _buildModeCard(
                  context: context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat Recommendation Mode',
                  description: 'Ask about any health concern and get AI-powered medicinal plant recommendations',
                  color: AppColors.blue,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
                    // No need to reload score - chat doesn't give coins
                  },
                  isTablet: isTablet,
                ),
                const SizedBox(height: 20),

                // Quiz Mode Card
                _buildModeCard(
                  context: context,
                  icon: Icons.quiz,
                  title: 'Quiz Mode',
                  description: 'Test your knowledge with AI-generated questions about medicinal plants',
                  color: AppColors.orange,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    );
                    _loadScore(); // Reload score and achievements after quiz
                  },
                  isTablet: isTablet,
                ),
                const SizedBox(height: 30),

                // Quick Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.monetization_on,
                        label: 'Coins',
                        value: '$_coins',
                        color: AppColors.gold,
                      ),
                      _buildStatItem(
                        icon: Icons.local_fire_department,
                        label: 'Streak',
                        value: _streak > 0 ? '$_streak' : '0',
                        color: AppColors.orange,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Achievements Section
                if (_hasBronze || _hasSilver || _hasGold) ...[
                  Container(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: AppColors.gold,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Your Achievements',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 22 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.start,
                          children: [
                            if (_hasBronze)
                              _buildAchievementCard(
                                'Bronze',
                                '🏅',
                                AppColors.orange,
                                '10 Streaks',
                                isTablet: isTablet,
                              ),
                            if (_hasSilver)
                              _buildAchievementCard(
                                'Silver',
                                '🥈',
                                Colors.grey,
                                '20 Streaks',
                                isTablet: isTablet,
                              ),
                            if (_hasGold)
                              _buildAchievementCard(
                                'Gold',
                                '🥇',
                                AppColors.gold,
                                '30 Streaks',
                                isTablet: isTablet,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 30 : 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isTablet ? 40 : 32,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: isTablet ? 24 : 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    String tier,
    String emoji,
    Color color,
    String description, {
    required bool isTablet,
  }) {
    return Container(
      width: isTablet ? 140 : 120,
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: isTablet ? 40 : 36),
          ),
          const SizedBox(height: 8),
          Text(
            tier,
            style: TextStyle(
              color: color,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 12 : 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showScoreDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: AppColors.gold, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatItem(
              icon: Icons.monetization_on,
              label: 'Total Coins',
              value: '$_coins',
              color: AppColors.gold,
            ),
            const SizedBox(height: 20),
            _buildStatItem(
              icon: Icons.local_fire_department,
              label: 'Current Streak',
              value: '$_streak',
              color: AppColors.orange,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primaryGreen, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

