import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

/// Onboarding screen with 3 slides explaining the app
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    const OnboardingSlide(
      icon: Icons.eco,
      title: 'Discover Medicinal Plants',
      description:
          'Get instant recommendations for natural remedies based on your health concerns. Learn about traditional medicinal plants and their uses.',
      color: Color(0xFF4CAF50),
    ),
    const OnboardingSlide(
      icon: Icons.emoji_events,
      title: 'Earn Coins & Streaks',
      description:
          'Gamify your learning! Earn coins for each correct query and build streaks. Unlock achievements as you explore more plants.',
      color: Color(0xFFFFD700),
    ),
    const OnboardingSlide(
      icon: Icons.chat_bubble_outline,
      title: 'Chat with AI Bot',
      description:
          'Simply type your disease or health concern, and our AI-powered bot will recommend the perfect medicinal plant with detailed preparation methods.',
      color: Color(0xFF2196F3),
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    return _buildSlide(_slides[index]);
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _buildIndicator(index == _currentPage),
                ),
              ),

              const SizedBox(height: 20),

              // Next button
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 30 : 20),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width > 600 ? 60 : 50,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Get Started 🌱'
                          : 'Next →',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isTablet = screenWidth > 600;
    
    return Padding(
      padding: EdgeInsets.all(isTablet ? 60 : isSmallScreen ? 30 : 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 40 : isSmallScreen ? 24 : 32),
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: slide.color,
                width: isTablet ? 4 : 3,
              ),
            ),
            child: Icon(
              slide.icon,
              size: isTablet ? 100 : isSmallScreen ? 60 : 80,
              color: slide.color,
            ),
          ),
          SizedBox(height: isTablet ? 50 : isSmallScreen ? 30 : 40),
          Text(
            slide.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 32 : isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 30 : isSmallScreen ? 16 : 20),
          Text(
            slide.description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 18 : isSmallScreen ? 14 : 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4CAF50)
            : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

