// ignore_for_file: equal_elements_in_set

import 'dart:math';

class ChatGPTService {
  static final Random random = Random();

  static final Map<String, List<String>> _resourceResponses = {
    'emergency_contacts': [
      "Here are important emergency numbers:\n\n🚨 Police: 100\n🚑 Ambulance: 108\n🚒 Fire: 101\n👩‍💼 Women's Helpline: 1091\n\nDon't hesitate to call if you need immediate help."
    ],
    'support_services': [
      "Here are support services available to help you:\n\n🤝 24/7 Counseling: 1800-XXX-XXXX\n⚖️ Legal Aid: 1800-XXX-XXXX\n🏥 Medical Support: 1800-XXX-XXXX\n\nWould you like me to explain more about any of these services?"
    ],
    'ngo_helplines': [
      "There are some wonderful organizations with caring people who want to help:\n\n💜 SNEHA Foundation: 022-2404 2627\n💪 Shakti Shalini: 011-24373737\n🤝 RAHI Foundation: 011-41666101\n\nThey have experienced counselors who are ready to listen and support you. Would you like me to tell you more about what they do?"
    ],
    'crisis_helplines': [
      "Sometimes talking to someone who understands can make a big difference. These helplines are available 24/7:\n\n🧠 Mental Health: 1800-599-0019\n💭 Crisis Support: 1800-233-3330\n💝 Counselling: 1800-572-7474\n\nThe people on these lines are trained to listen without judgment. Would you like to know what to expect when you call?"
    ],
    'quick_help': [
      "I want to make sure you know all your options for getting help quickly:\n\n🆘 Use the Emergency Button in our app\n👮‍♀️ Police: 100 - for immediate danger\n🚑 Ambulance: 108 - for medical help\n👩‍💼 Women's Helpline: 1091 - for support and guidance\n\nYour safety is my priority. Which of these would you feel most comfortable using?"
    ]
  };

  static final Map<String, List<String>> _defaultResponses = {
    'greeting': [
      "Hi there 👋 I'm your support assistant, and I'm really glad you reached out. How are you feeling right now? Remember, this is a safe space to share whatever's on your mind.",
      "Hello! 💝 I'm here to support you through this. Sometimes the first step is just talking about it. Would you like to tell me what's troubling you?",
      "Welcome! I'm your personal support assistant, and I'm here to listen and help. How are you doing today? Take your time - we can go at whatever pace feels comfortable for you.",
      "Hi! Thank you for reaching out 💜 That takes courage. I'm here to listen without judgment and help you find the support you need. What's on your mind?",
      "Hello! I'm so glad you're here. This is a safe space where you can share anything that's bothering you. How can I support you today?"
    ],
    'emergency': [
      "I can hear that you're in a difficult and scary situation right now. Your safety is my absolute top priority. I'm right here with you - would you like me to help you contact emergency services? We can do this together.",
      "I understand you need help right away, and I'm taking this very seriously. There's an Emergency Button in our app that can connect you with immediate help. Would you like me to guide you through using it? I'll stay with you through the process.",
      "I'm hearing that you're in danger, and I want you to know that help is available right now. We can get you support immediately - either through our Emergency feature or by calling emergency services. Which would feel safer for you?",
      "Your safety is the most important thing right now. I'm here with you, and we're going to get you help. Would you prefer to use our Emergency Button, or would you like the numbers to call directly? I can explain how both options work.",
      "I'm very concerned about your safety, and I want you to know you're not alone in this. Let's get you help right away. I can guide you through using our Emergency Services feature, or we can talk about other immediate options. What feels most comfortable for you?"
    ],
    'support': [
      "I hear how difficult this is for you, and I want you to know you're incredibly brave for sharing this. There are people who specialize in helping with situations just like yours - would you like to know about them? We can take this one step at a time.",
      "Thank you for trusting me with this. You're not alone - many others have faced similar challenges and found help through our support services. Would you like to hear about what's available? We can focus on whatever feels most helpful right now.",
      "What you're going through sounds really challenging, and it's completely normal to need support. I know about several services that could help - would you like me to tell you about them? We can start with whatever feels most comfortable for you.",
      "I'm really glad you're sharing this with me. It takes strength to reach out, and you've already taken that important first step. There are caring professionals who would love to help - would you like to learn about your options?",
      "I want you to know that what you're feeling is valid, and there are people who understand what you're going through. Would you like to hear about some support services that have helped others in similar situations? We can explore them together."
    ],
    'safety': [
      "Your safety is really important, and I want to help you feel more secure. Would you like to work together on creating a safety plan that's specifically for your situation? We can take it step by step.",
      "I understand you're worried about your safety, and I'm here to help. We can talk about practical ways to help you feel more secure, like identifying safe places and trusted people. Would that be helpful?",
      "Let's focus on keeping you safe. I can help you create a personal safety strategy that works for your specific situation. Would you like to start by talking about immediate safety measures?",
      "I hear your concerns about safety, and they're completely valid. We can work together on both immediate and longer-term safety plans. Would you like to start by identifying some safe spaces or trusted contacts?",
      "Your safety is my priority, and I want to help you develop a plan that makes you feel more secure. We can start small and build from there. What would help you feel safer right now?"
    ],
    'empowerment': [
      "I want you to know that you have incredible strength within you - I can hear it in your words. You deserve to feel safe and respected. Would you like to talk about some steps you can take to feel more in control?",
      "Your feelings and experiences are valid, and you have the right to make choices that protect your wellbeing. I'm here to support whatever decisions feel right for you. What kind of changes would you like to see?",
      "You're showing real courage by reaching out and sharing this. That takes strength. Remember, you have the power to make changes, and I'm here to support you every step of the way. What feels like a manageable first step?",
      "What you're going through is not your fault, and you deserve support and care. You've already shown strength by reaching out. Would you like to explore what options are available to help you move forward?",
      "I believe in your ability to make positive changes in your life, and you don't have to do it alone. We can take this journey one step at a time, at whatever pace feels right for you. What would feel like a good first step?"
    ],
    'default': [
      "I'm here to listen and support you through this. Sometimes talking things through can help us figure out the next steps. What's on your mind right now?",
      "Thank you for reaching out. I want you to know that this is a safe space to share whatever you're going through. Would you like to tell me more about what's troubling you?",
      "I hear you, and I want you to know you're not alone in this. Sometimes it helps to start by sharing what's most pressing on your mind. What would you like to focus on?",
      "I'm here to support you in whatever way feels most helpful. We can talk about anything that's concerning you. What feels most important to discuss right now?",
      "This is a safe space to talk about whatever is on your mind. There's no judgment here - just support and understanding. Would you like to share what's troubling you?"
    ],
    'affirmative': [
      "I'm really glad you're open to exploring some help options. I know about several resources that could be really helpful for your situation. Would you like me to start with the most relevant ones?",
      "Thank you for being willing to look at some support options. That's a really positive step. I can help you find the services that best match what you need. Shall we start with the most immediate ones?",
      "I appreciate your trust in letting me help. There are several options that have helped others in similar situations. Would you like me to explain how they work?",
      "That's a really positive step you're taking. I'll help you understand all your options so you can choose what feels right for you. Where would you like to start?",
      "I'm here to help you explore all the possibilities. There are several resources available, and we can go through them at your pace. What type of support feels most important right now?"
    ]
  };

  static String _getDefaultResponse(String message) {
    final String lowercaseMessage = message.toLowerCase();

    final Map<String, Map<String, dynamic>> keywordCategories = {
      'greeting': {
        'keywords': <String>{
          'hi',
          'hello',
          'hey',
          'greetings',
          'good morning',
          'good afternoon',
          'good evening',
          'help',
          'start',
          'begin'
        },
        'requireExactMatch': true
      },
      'emergency': {
        'keywords': {
          'urgent',
          'emergency',
          'danger',
          'scared',
          'threat',
          'unsafe',
          'help me',
          'violence',
          'abuse',
          'hurt',
          'injured',
          'immediate',
          'critical',
          'serious',
          'life',
          'death',
          'suicide',
          'kill',
          'attack',
          'beaten'
        },
        'requireExactMatch': false,
        'appendResource': 'emergency_contacts'
      },
      'mental_health': {
        'keywords': {
          'depressed',
          'anxiety',
          'suicide',
          'mental',
          'stress',
          'worried',
          'fear',
          'scared',
          'panic',
          'tension',
          'trauma',
          'nightmare',
          'cant sleep',
          'no sleep',
          'feeling low',
          'feeling down'
        },
        'requireExactMatch': false,
        'appendResource': 'crisis_helplines'
      },
      'support': {
        'keywords': {
          'help',
          'support',
          'assist',
          'guidance',
          'need help',
          'advice',
          'what to do',
          'how to',
          'resources',
          'services',
          'counseling',
          'counsel',
          'therapy',
          'therapist',
          'professional'
        },
        'requireExactMatch': false,
        'appendResource': 'support_services'
      },
      'safety': {
        'keywords': {
          'safe',
          'safety',
          'protect',
          'secure',
          'protection',
          'escape',
          'leave',
          'run away',
          'hide',
          'shelter',
          'secure',
          'plan',
          'what should i do',
          'where to go'
        },
        'requireExactMatch': false,
        'appendResource': 'quick_help'
      },
      'legal': {
        'keywords': {
          'legal',
          'law',
          'police',
          'rights',
          'court',
          'lawyer',
          'advocate',
          'file',
          'complaint',
          'report',
          'fir',
          'case'
        },
        'requireExactMatch': false,
        'appendResource': 'support_services'
      },
      'affirmative': {
        'keywords': {
          'yes',
          'yeah',
          'sure',
          'okay',
          'ok',
          'yep',
          'yup',
          'please',
          'great',
          'good',
          'right',
          'fine',
          'correct',
          'continue',
          'proceed'
        },
        'requireExactMatch': true
      }
    };

    // Check for keywords and return appropriate response
    for (var entry in keywordCategories.entries) {
      final category = entry.key;
      final categoryData = entry.value;
      final keywords = categoryData['keywords'] as Set<String>;
      final requireExactMatch = categoryData['requireExactMatch'] as bool;
      final appendResource = categoryData['appendResource'] as String?;

      bool matched = false;
      if (requireExactMatch) {
        matched = keywords.any((keyword) => lowercaseMessage == keyword);
      } else {
        matched = keywords.any((keyword) => lowercaseMessage.contains(keyword));
      }

      if (matched) {
        var response = '';

        // Get base response
        if (_defaultResponses.containsKey(category)) {
          response = _defaultResponses[category]![
              random.nextInt(_defaultResponses[category]!.length)];
        } else {
          response = _defaultResponses['support']![
              random.nextInt(_defaultResponses['support']!.length)];
        }

        // Append resource information if specified
        if (appendResource != null &&
            _resourceResponses.containsKey(appendResource)) {
          response += "\n\n${_resourceResponses[appendResource]![0]}";
        }

        return response;
      }
    }

    // Check for numbers in the message (possible emergency number queries)
    if (RegExp(r'\d{3,}').hasMatch(lowercaseMessage)) {
      return "Here are all the emergency numbers you might need:\n\n${_resourceResponses['emergency_contacts']![0]}";
    }

    // If no matches found, return default response with quick help
    var defaultResponse = _defaultResponses['default']![
        random.nextInt(_defaultResponses['default']!.length)];
    return "$defaultResponse\n\n${_resourceResponses['quick_help']![0]}";
  }

  static Future<String> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return _getDefaultResponse('default');
    }
    return _getDefaultResponse(message);
  }
}
