import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gemini_service.dart';
import '../widgets/score_badge.dart';
import 'result_screen.dart';
import '../utils/app_colors.dart';

/// Quiz screen with AI-generated MCQ questions
class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final GeminiService _geminiService = GeminiService();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _coins = 0;
  int _streak = 0;
  int _correctStreak = 0;
  bool _isLoading = true;
  bool _isLoadingQuestion = false;
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadScore();
    _loadQuestions();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('coins') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
    });
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins);
    await prefs.setInt('streak', _streak);
    await prefs.setInt('highest_streak', _streak > (prefs.getInt('highest_streak') ?? 0) ? _streak : (prefs.getInt('highest_streak') ?? 0));
  }

  Future<void> _checkAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStreak = _streak;
    
    // Check and unlock achievements
    if (currentStreak >= 10 && !(prefs.getBool('achievement_bronze') ?? false)) {
      await prefs.setBool('achievement_bronze', true);
      _showAchievementUnlocked('Bronze', '🏅', AppColors.orange);
    }
    if (currentStreak >= 20 && !(prefs.getBool('achievement_silver') ?? false)) {
      await prefs.setBool('achievement_silver', true);
      _showAchievementUnlocked('Silver', '🥈', Colors.grey);
    }
    if (currentStreak >= 30 && !(prefs.getBool('achievement_gold') ?? false)) {
      await prefs.setBool('achievement_gold', true);
      _showAchievementUnlocked('Gold', '🥇', AppColors.gold);
    }
  }

  void _showAchievementUnlocked(String tier, String emoji, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color, width: 3),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Achievement Unlocked!',
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$tier Card',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You reached $_streak consecutive correct answers!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Awesome!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
    
    // Extra confetti for achievement
    _confettiController.play();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    // Generate 10 dynamic questions about medicinal plants and medicine
    for (int i = 0; i < 10; i++) {
      // Pass previous questions to avoid repetition
      final question = await _geminiService.generateQuizQuestion(
        previousQuestions: _questions,
      );
      if (question != null) {
        _questions.add(question);
      }
      // Small delay between requests to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _selectAnswer(String answer) async {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });

    final currentQuestion = _questions[_currentQuestionIndex];
    final correctAnswer = currentQuestion['answer'] as String;

    if (answer == correctAnswer) {
      // Correct answer - 10 coins per right answer
      setState(() {
        _score++;
        _coins += 10; // 1 right answer = 10 coins
        _streak++; // Increase streak only on correct answer
        _correctStreak = _streak; // Track current streak
      });

      await _saveScore();
      await _checkAchievements();

      // Haptic feedback
      try {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 200);
        }
      } catch (e) {
        // Vibration not available
      }

      // Confetti animation
      _confettiController.play();
    } else {
      // Wrong answer - reset streak (hide it)
      setState(() {
        _streak = 0;
        _correctStreak = 0;
      });

      await _saveScore();
    }

    // Move to next question after delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      // Quiz completed
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          coinsEarned: _coins,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
            const Icon(Icons.quiz, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isTablet ? 'Quiz Mode - Question ${_currentQuestionIndex + 1}/10' : 'Quiz Mode',
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
            child: ScoreBadge(coins: _coins, streak: _streak),
          ),
        ],
      ),
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
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Generating questions...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          else if (_questions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Failed to Load Questions',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to connect to Med AI servers.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your internet connection and try again.',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: const Text('Go Back', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 40 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Score: $_score/${_questions.length}',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) / _questions.length,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Question
                  Container(
                    padding: EdgeInsets.all(isTablet ? 30 : 20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Options
                  ...((_questions[_currentQuestionIndex]['options'] as List)
                      .map((option) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _buildOptionButton(
                              option.toString(),
                              isTablet: isTablet,
                            ),
                          ))
                      .toList()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, {required bool isTablet}) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final correctAnswer = currentQuestion['answer'] as String;
    final isSelected = _selectedAnswer == option;
    final isCorrect = option == correctAnswer;

    Color? backgroundColor;
    Color? borderColor;
    IconData? icon;

    if (_showResult) {
      if (isCorrect) {
        backgroundColor = AppColors.primaryGreen.withOpacity(0.3);
        borderColor = AppColors.primaryGreen;
        icon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
        icon = Icons.cancel;
      } else {
        backgroundColor = AppColors.cardBackground;
        borderColor = Colors.white.withOpacity(0.3);
      }
    } else {
      backgroundColor = isSelected
          ? AppColors.primaryGreen.withOpacity(0.3)
          : AppColors.cardBackground;
      borderColor = isSelected
          ? AppColors.primaryGreen
          : Colors.white.withOpacity(0.3);
    }

    return InkWell(
      onTap: () => _selectAnswer(option),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: borderColor!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isCorrect ? AppColors.primaryGreen : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

