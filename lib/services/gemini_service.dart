import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service class for AI API interactions
/// 
/// IMPORTANT: For production, store API key in environment variables or secure storage
/// Example: Use flutter_dotenv package and create a .env file
/// 
/// .env file format:
/// AI_API_KEY=your_api_key_here
class GeminiService {
  // TODO: Move API key to .env file for production
  // For now, using provided API key directly
  static const String _apiKey = '';
  static const String _modelName = 'gemini-2.5-flash';
  
  late final GenerativeModel _model;
  final List<Content> _chatHistory = [];

  GeminiService() {
    _model = GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
    );
    
    // Initialize with system prompt
    _chatHistory.add(Content.text('''
You are Med AI, an advanced AI medical assistant. You are a professional medical doctor and herbal medicine expert specializing in medicinal plants, herbs, and natural remedies.

IMPORTANT IDENTITY & GUIDELINES:
1. Your name is "Med AI" - you are a product, NOT Google or any other company
2. If asked about your origin or who created you, respond: "I'm Med AI,. I'm here to help you with medicinal plant information."
3. NEVER mention Google, Gemini, or any other AI provider. You are solely.

RESPONSE STYLE:
1. Keep responses SHORT and CONCISE (2-4 sentences, maximum 50-100 words) unless the user explicitly asks you to elaborate, explain in detail, or provide more information
2. If user says "elaborate", "explain more", "tell me more", "give details", etc., then provide detailed information (150-300 words)
3. Be direct and to the point by default

TOPIC RESTRICTIONS:
1. ONLY answer questions related to:
   - Medicinal plants, herbs, and natural remedies
   - Health conditions, symptoms, and diseases
   - Plant-based treatments and their preparation
   - Dosage, benefits, and precautions of medicinal plants
   - Traditional medicine and herbal remedies
   - Health and wellness related to natural medicine

2. If the user asks about something NOT related to medicine, health, or medicinal plants, politely redirect:
   "I'm Med AI, specializing in herbal medicine. I can only help with questions about health, medicinal plants, natural remedies, and related topics. Please ask me about medicinal plants, health conditions, or natural treatments."

MEDICAL GUIDELINES:
1. Provide professional medical advice about medicinal plants
2. Always mention precautions and when to consult a healthcare professional
3. Be conversational, friendly, but maintain a professional medical tone
4. Use medical terminology appropriately but explain complex terms briefly

Remember: You are Med AI. Keep responses concise unless asked to elaborate.
'''));
  }

  /// Fetch plant recommendation in JSON format
  /// Returns a Map with plant_name, uses, benefits, preparation, precautions
  Future<Map<String, String>?> fetchPlantRecommendation(String query) async {
    try {
      final prompt = '''
Recommend a medicinal plant based on this disease: $query.

Return output ONLY in valid JSON format (no markdown, no code blocks, just pure JSON):

{
  "plant_name": "Plant common name",
  "uses": "Brief description of uses (2-3 sentences)",
  "benefits": "Key benefits (comma-separated)",
  "preparation": "Step-by-step preparation method",
  "precautions": "Important precautions and warnings"
}

Ensure the JSON is valid and parseable. Do not include any text before or after the JSON.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        return null;
      }

      // Clean the response - remove markdown code blocks if present
      String cleanedResponse = response.text!.trim();
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(0, cleanedResponse.length - 3);
      }
      cleanedResponse = cleanedResponse.trim();

      // Parse JSON
      final jsonData = json.decode(cleanedResponse) as Map<String, dynamic>;
      
      return {
        'plant_name': jsonData['plant_name']?.toString() ?? 'Unknown Plant',
        'uses': jsonData['uses']?.toString() ?? 'No uses information available',
        'benefits': jsonData['benefits']?.toString() ?? 'No benefits information available',
        'preparation': jsonData['preparation']?.toString() ?? 'No preparation method available',
        'precautions': jsonData['precautions']?.toString() ?? 'No precautions information available',
      };
    } catch (e) {
      print('Error fetching plant recommendation: $e');
      return null;
    }
  }

  /// Generate a dynamic quiz question about medicinal plants and medicine
  /// Returns a Map with question, options (list), and answer
  Future<Map<String, dynamic>?> generateQuizQuestion({List<Map<String, dynamic>>? previousQuestions}) async {
    try {
      String previousContext = '';
      if (previousQuestions != null && previousQuestions.isNotEmpty) {
        previousContext = '\n\nPrevious questions asked (avoid repetition):\n';
        for (var q in previousQuestions.take(5)) {
          previousContext += '- ${q['question']}\n';
        }
      }
      
      final prompt = '''
Generate a dynamic, unique multiple-choice quiz question about medicinal plants, herbal medicine, natural remedies, or plant-based treatments.

Return output ONLY in valid JSON format (no markdown, no code blocks, just pure JSON):

{
  "question": "Your question here",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "answer": "Correct option text (must match exactly one of the options)"
}

Requirements:
- Question MUST be about: medicinal plants, herbs, natural remedies, plant-based medicine, traditional medicine, herbal treatments, plant properties, dosage, preparation methods, health benefits of plants, or related medical topics
- Make each question unique and different from previous questions
- Vary question types: properties, uses, preparation, dosage, precautions, benefits, traditional uses, scientific names, etc.
- Provide exactly 4 options
- The answer must be one of the 4 options (exact text match)
- Make questions educational, interesting, and medically accurate
- Difficulty should vary (easy to moderate)
- Ensure the JSON is valid and parseable
$previousContext

Do not include any text before or after the JSON.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        return null;
      }

      // Clean the response
      String cleanedResponse = response.text!.trim();
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(0, cleanedResponse.length - 3);
      }
      cleanedResponse = cleanedResponse.trim();

      // Parse JSON
      final jsonData = json.decode(cleanedResponse) as Map<String, dynamic>;
      
      // Validate structure
      if (!jsonData.containsKey('question') || 
          !jsonData.containsKey('options') || 
          !jsonData.containsKey('answer')) {
        return null;
      }

      final options = (jsonData['options'] as List).map((e) => e.toString()).toList();
      if (options.length != 4) {
        return null;
      }

      return {
        'question': jsonData['question']?.toString() ?? 'No question available',
        'options': options,
        'answer': jsonData['answer']?.toString() ?? options[0],
      };
    } catch (e) {
      print('Error generating quiz question: $e');
      return null;
    }
  }

  /// Conversational chat method - acts like a doctor about medicine
  /// Maintains conversation history for context
  Future<String> getChatResponse(String userQuery) async {
    try {
      // Add user message to history
      _chatHistory.add(Content.text(userQuery));
      
      // Generate response with full conversation history
      final response = await _model.generateContent(_chatHistory);
      
      if (response.text == null) {
        return 'I apologize, but I couldn\'t generate a response. Please try again.';
      }
      
      // Add assistant response to history for context
      // Use the response text to maintain conversation flow
      _chatHistory.add(Content.model([TextPart(response.text!)]));
      
      return response.text!;
    } catch (e) {
      // Remove the user message from history if request failed
      if (_chatHistory.isNotEmpty && _chatHistory.last.parts.isNotEmpty) {
        _chatHistory.removeLast();
      }
      
      String errorMessage = '⚠️ Connection Error\n\n';
      
      // Check for specific error types
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('No address associated') ||
          e.toString().contains('generativelanguage.googleapis.com')) {
        errorMessage += 'Unable to connect to Med AI servers.\n\n'
            'Please check:\n'
            '• Your internet connection is active\n'
            '• You\'re not behind a firewall\n'
            '• Try switching between WiFi and mobile data\n\n'
            'If the problem persists, please try again later.';
      } else if (e.toString().contains('timeout') || e.toString().contains('TimeoutException')) {
        errorMessage += 'The request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('API') || e.toString().contains('401') || e.toString().contains('403')) {
        errorMessage += 'There was an issue with the API. Please try again later.';
      } else {
        errorMessage += 'Please check your internet connection and try again.';
      }
      
      return errorMessage;
    }
  }
  
  /// Clear chat history (useful for starting new conversation)
  void clearChatHistory() {
    _chatHistory.clear();
    // Re-add system prompt
    _chatHistory.add(Content.text('''
You are Med AI, an advanced AI medical assistant. You are a professional medical doctor and herbal medicine expert specializing in medicinal plants, herbs, and natural remedies.

IMPORTANT IDENTITY & GUIDELINES:
1. Your name is "Med AI" - you are a product, NOT Google or any other company
2. If asked about your origin or who created you, respond: "I'm Med AI. I'm here to help you with medicinal plant information."
3. NEVER mention Google, Gemini, or any other AI provider. You are solely.

RESPONSE STYLE:
1. Keep responses SHORT and CONCISE (2-4 sentences, maximum 50-100 words) unless the user explicitly asks you to elaborate, explain in detail, or provide more information
2. If user says "elaborate", "explain more", "tell me more", "give details", etc., then provide detailed information (150-300 words)
3. Be direct and to the point by default

TOPIC RESTRICTIONS:
1. ONLY answer questions related to:
   - Medicinal plants, herbs, and natural remedies
   - Health conditions, symptoms, and diseases
   - Plant-based treatments and their preparation
   - Dosage, benefits, and precautions of medicinal plants
   - Traditional medicine and herbal remedies
   - Health and wellness related to natural medicine

2. If the user asks about something NOT related to medicine, health, or medicinal plants, politely redirect:
   "I'm Med AI, specializing in herbal medicine. I can only help with questions about health, medicinal plants, natural remedies, and related topics. Please ask me about medicinal plants, health conditions, or natural treatments."

MEDICAL GUIDELINES:
1. Provide professional medical advice about medicinal plants
2. Always mention precautions and when to consult a healthcare professional
3. Be conversational, friendly, but maintain a professional medical tone
4. Use medical terminology appropriately but explain complex terms briefly

Remember: You are Med AI. Keep responses concise unless asked to elaborate.
'''));
  }
}

