import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/app_logo.dart';

/// About screen with app credits and information
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
            const Icon(Icons.info_outline, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              isTablet ? 'About - AI Medicinal Plants' : 'About',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                AppLogo(
                  size: isTablet ? 120 : 100,
                  showText: false,
                ),
                const SizedBox(height: 24),

                // App Name
                Text(
                  'AI-Powered Medicinal Plant\nRecommendation System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                const SizedBox(height: 40),

                // Description Card
                _buildInfoCard(
                  icon: Icons.description,
                  title: 'About This App',
                  content:
                      'Discover natural remedies powered by AI! This app provides personalized medicinal plant recommendations based on your health concerns. Learn about traditional plants, their uses, benefits, and preparation methods through an interactive, gamified experience.',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 20),

                // Features Card
                _buildInfoCard(
                  icon: Icons.star,
                  title: 'Features',
                  content:
                      '• Chat with AI Bot for instant plant recommendations\n'
                      '• Quiz Mode with AI-generated questions\n'
                      '• Earn coins and build streaks\n'
                      '• Detailed plant information and preparation methods\n'
                      '• Beautiful, modern herbal-themed UI',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 20),

                // Technology Card
                _buildInfoCard(
                  icon: Icons.code,
                  title: 'Technology',
                  content:
                      'Built with Flutter and powered by advanced AI technology. All recommendations and quiz questions are generated dynamically using AI.',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 20),

                // Credits Card
                // _buildInfoCard(
                //   icon: Icons.people,
                //   title: 'Built by RPN Tech World',
                //   content:
                //       'Developed by: RPN Tech World\n'
                //       'Contact:\n'
                //       'Phone: +91 9751448561\n'
                //       'Email: helo@rpntechworld.com\n'
                //       'Website: www.rpntechworld.com\n\n',
                //   isTablet: isTablet,
                // ),
                const SizedBox(height: 20),

                // Important Disclaimer Card
                _buildInfoCard(
                  icon: Icons.warning_amber,
                  title: '⚠️ Important Disclaimer',
                  content:
                      '⚠️ CAUTION: All information provided in this app is fully AI-generated. Do NOT depend solely on this AI for medical decisions.\n\n'
                      'This app provides educational information about medicinal plants. It is NOT a substitute for professional medical advice, diagnosis, or treatment.\n\n'
                      'ALWAYS consult with a qualified healthcare provider or real doctor before using any medicinal plants, especially if you have existing health conditions or are taking medications.\n\n'
                      'The AI-generated content may contain errors or inaccuracies. Use this app for educational purposes only.',
                  isTablet: isTablet,
                  color: Colors.red,
                ),
                const SizedBox(height: 30),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 60 : 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
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
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required bool isTablet,
    Color? color,
  }) {
    final cardColor = color ?? AppColors.primaryGreen;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cardColor, size: isTablet ? 28 : 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: cardColor,
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 16 : 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

