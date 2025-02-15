import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ChatGPTService {
  static const String _apiKey =
      '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';
  static const String _apiUrl = 'https://api.claude.ai/v1/messages';

  // Default responses for different types of messages
  static final Map<String, List<String>> _defaultResponses = {
    'greeting': [
      "Hello! I'm here to help you. How are you feeling today?",
      "Hi there! I'm your support assistant. What's on your mind?",
      "Welcome! I'm here to listen and support you. How can I help?",
    ],
    'emergency': [
      "I understand you're in a difficult situation. Please contact emergency services immediately by using the Emergency button on the home screen.",
      "Your safety is our top priority. Please use the Emergency Services option in the app to get immediate help.",
      "This sounds serious. Please reach out to emergency services right away. You can use our Emergency button for quick access to help.",
    ],
    'support': [
      "I hear you, and I want you to know that you're not alone in this. Would you like information about our support services?",
      "Thank you for sharing this with me. We have several support services available. Would you like to know more about them?",
      "I understand this is difficult. We have professional support services that can help you through this situation.",
    ],
    'default': [
      "I'm here to support you. Would you like to know about the resources and help available?",
      "Thank you for reaching out. How can I assist you further?",
      "I'm listening and I'm here to help. Would you like to know about our support services?",
      "Your well-being is important. How can I help you today?",
    ],
  };

  static String _getDefaultResponse(String message) {
    final lowercaseMessage = message.toLowerCase();
    final random = Random();

    // Check message content for keywords and return appropriate response
    if (lowercaseMessage.contains('hello') || 
        lowercaseMessage.contains('hi') || 
        lowercaseMessage.contains('hey')) {
      return _defaultResponses['greeting']![random.nextInt(_defaultResponses['greeting']!.length)];
    }
    
    if (lowercaseMessage.contains('emergency') || 
        lowercaseMessage.contains('help') || 
        lowercaseMessage.contains('urgent') ||
        lowercaseMessage.contains('danger')) {
      return _defaultResponses['emergency']![random.nextInt(_defaultResponses['emergency']!.length)];
    }
    
    if (lowercaseMessage.contains('support') || 
        lowercaseMessage.contains('assistance') || 
        lowercaseMessage.contains('guidance')) {
      return _defaultResponses['support']![random.nextInt(_defaultResponses['support']!.length)];
    }

    return _defaultResponses['default']![random.nextInt(_defaultResponses['default']!.length)];
  }

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-3-opus-20240229',
          'max_tokens': 1000,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a compassionate support assistant for victims. Provide helpful and empathetic responses.',
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = data['content'][0]['text'];
        return apiResponse.isNotEmpty ? apiResponse : _getDefaultResponse(message);
      } else {
        print('Error Status Code: ${response.statusCode}');
        print('Error Response: ${response.body}');
        return _getDefaultResponse(message);
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      return _getDefaultResponse(message);
    }
  }
}
