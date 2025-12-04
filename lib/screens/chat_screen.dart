import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/score_badge.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/plant_card.dart';
import '../widgets/app_logo.dart';
import '../services/gemini_service.dart';
import 'about_screen.dart';

/// Main chat screen with gamified features
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  List<ChatMessage> _messages = [];
  int _totalQueries = 0;
  bool _isTyping = false;
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _loadScore();
    _addWelcomeMessage();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalQueries = prefs.getInt('total_queries') ?? 0;
    });
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_queries', _totalQueries);
  }

  void _addWelcomeMessage() async {
    // Get initial greeting from AI doctor
    try {
      final greeting = await _geminiService.getChatResponse("Hello");
      setState(() {
        _messages.add(ChatMessage(
          text: greeting,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Hello! I'm Med AI, your medical assistant. 🌿\n\n"
              "I specialize in herbal medicine and natural remedies. I can help with:\n"
              "• Medicinal plants and herbs\n"
              "• Natural remedies and treatments\n"
              "• Health conditions and symptoms\n"
              "• Plant-based medicine preparation\n\n"
              "Ask me anything about medicinal plants! (Say 'elaborate' for detailed answers)\n\n"
              "⚠️ IMPORTANT: All information is AI-generated. Consult a real doctor for medical decisions.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _textController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Get AI response
    setState(() {
      _isTyping = true;
      _totalQueries++;
    });

    try {
      // Get conversational response from AI doctor
      final response = await _geminiService.getChatResponse(text);
      
      setState(() {
        _isTyping = false;
      });

      // Chat mode - no coins, just conversation
      // Coins are only earned in Quiz mode for correct answers
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
      });

      setState(() {
        _messages.add(ChatMessage(
          text: "I apologize, but I encountered an error while processing your query.\n\n"
              "Error: ${e.toString()}\n\n"
              "Please check your internet connection and try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });

      _scrollToBottom();
    }
  }

  void _showPlantCard(Map<String, String> plantData) {
    showDialog(
      context: context,
      builder: (context) => PlantCard(
        plantName: plantData['plant_name'] ?? 'Unknown Plant',
        uses: plantData['uses'] ?? 'No uses information',
        preparation: plantData['preparation'] ?? 'No preparation method',
        imagePath: plantData['image'],
        scientificName: plantData['scientific_name'],
        benefits: plantData['benefits'],
        precautions: plantData['precautions'],
        duration: plantData['duration'],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Row(
          children: [
            const AppLogoIcon(size: 28, color: Color(0xFF4CAF50)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isTablet ? 'AI Medicinal Plants - Your Natural Health Guide' : 'AI Medicinal Plants',
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
          // About button
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
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708, // Down
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),

          // Chat messages with proper spacing
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + (isTablet ? 100 : 80),
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 16 : 12,
              ),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                    child: const TypingIndicator(),
                  );
                }
                final message = _messages[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                  child: ChatBubble(
                    message: message.text,
                    isUser: message.isUser,
                    timestamp: message.timestamp,
                  ),
                );
              },
            ),
          ),

          // Input area
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 16 : 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: isTablet ? 2 : 1,
                          decoration: InputDecoration(
                            hintText: isTablet 
                                ? 'Type a disease or health concern (e.g., Fever, Cough, Diabetes, Headache, Skin Allergy, Acne, Constipation, Hair Loss, High Blood Pressure, Asthma, Wounds, Arthritis, Stress, Insomnia, Cold, Digestion)...'
                                : 'Type a disease or health concern...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: isTablet ? 14 : 16,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1B5E20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 24 : 20,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          iconSize: isTablet ? 28 : 24,
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, String>? plantData;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.plantData,
  });
}

