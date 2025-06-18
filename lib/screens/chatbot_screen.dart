import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../services/chatgpt_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenErrorBoundary extends StatelessWidget {
  final Widget child;

  const _ChatbotScreenErrorBoundary({required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        FlutterError.onError = (FlutterErrorDetails details) {
          debugPrint('Error in ChatbotScreen: ${details.exception}');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Material(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The chat encountered an error. Please try again later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ChatbotScreen(),
                            ),
                          );
                        },
                        child: const Text('Reload Chat'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        };
        return child;
      },
    );
  }
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isError = false;
  bool _showSuggestions = true;
  bool _showWelcomeCard = true;
  bool _isDisposed = false;

  static const List<String> _quickResponses = [
    "I need help with a situation",
    "What should I do in an emergency?",
    "How can I stay safe?",
    "I want to report an incident",
  ];

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
    _messageFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_messageFocusNode.hasFocus && _showSuggestions) {
      setState(() => _showSuggestions = false);
    }
  }

  void _addInitialMessage() {
    if (!_isDisposed) {
      _addBotMessage(
        "Hello! ",
        isError: false,
      );
    }
  }

  void _hideWelcomeCard() {
    if (!_isDisposed) {
      setState(() {
        _showWelcomeCard = false;
      });
      _addWelcomeMessages();
    }
  }

  void _addWelcomeMessages() {
    if (_isDisposed) return;

    _addBotMessage(
      "I'm your support assistant, here to help you through any situation.",
      isError: false,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_isDisposed) {
        _addBotMessage(
          "Your safety and well-being are my top priority. Everything you share here is completely confidential.",
          isError: false,
        );
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.removeListener(_onFocusChange);
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _addBotMessage(String message, {bool isError = false}) {
    if (_isDisposed) return;

    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: false,
        timestamp: DateTime.now(),
        isError: isError,
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_isDisposed || !_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isDisposed && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isDisposed) return;

    final userMessage = text;
    _messageController.clear();
    _messageFocusNode.requestFocus();

    setState(() {
      _showSuggestions = false;
      _messages.add(ChatMessage(
        message: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
        isError: false,
      ));
      _isLoading = true;
      _isError = false;
    });

    try {
      final response = await ChatGPTService.sendMessage(userMessage);
      if (_isDisposed) return;

      if (response.isNotEmpty) {
        _addBotMessage(response);
      } else {
        _addBotMessage(
          "I apologize, but I couldn't generate a response. Please try again.",
          isError: true,
        );
        if (!_isDisposed) {
          setState(() => _isError = true);
        }
      }
    } catch (e) {
      debugPrint('Error in _handleSubmitted: $e');
      if (!_isDisposed) {
        _addBotMessage(
          "I'm having trouble connecting to the server. Please check your internet connection and try again.",
          isError: true,
        );
        setState(() => _isError = true);
      }
    } finally {
      if (!_isDisposed) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return _ChatbotScreenErrorBoundary(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Chat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 22,
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'We\'re here to help',
                    speed: const Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
                displayFullTextOnTap: true,
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [Colors.blue.shade900, Colors.blue.shade800]
                    : [Colors.blue, Colors.blue.shade600],
              ),
            ),
          ),
          elevation: isDark ? 0 : 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text('About This Chat'),
                      ],
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '• This is a safe space to seek help and guidance'),
                        SizedBox(height: 8),
                        Text('• All conversations are confidential'),
                        SizedBox(height: 8),
                        Text(
                            '• You can ask any questions about safety or support'),
                        SizedBox(height: 8),
                        Text('• Emergency numbers are always available'),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    actions: [
                      TextButton(
                        child:
                            Text('Close', style: TextStyle(color: Colors.blue)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        colorScheme.surface,
                        Theme.of(context).scaffoldBackgroundColor,
                      ]
                    : [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: Column(
              children: [
                if (_isError)
                  Container(
                    color: isDark
                        ? colorScheme.error.withOpacity(0.2)
                        : Colors.red[50],
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color:
                                isDark ? colorScheme.error : Colors.red[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'There was an error with the connection. Messages may not be delivered.',
                            style: TextStyle(
                              color:
                                  isDark ? colorScheme.error : Colors.red[700],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _isError = false),
                          color: isDark ? colorScheme.error : Colors.red[700],
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message =
                              _messages[_messages.length - 1 - index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              children: [
                                BubbleSpecialThree(
                                  text: message.message,
                                  color: message.isError
                                      ? (isDark
                                          ? Colors.red.shade900
                                          : Colors.red[100]!)
                                      : message.isUser
                                          ? (isDark
                                              ? Colors.blue.shade700
                                              : Colors.blue)
                                          : (isDark
                                              ? Colors.grey.shade800
                                              : Colors.white),
                                  tail: true,
                                  isSender: message.isUser,
                                  textStyle: TextStyle(
                                    color: message.isUser || isDark
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                if (!message.isUser)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _formatTimestamp(message.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (_showWelcomeCard)
                        Positioned.fill(
                          child: Container(
                            color: isDark
                                ? Colors.black.withOpacity(0.7)
                                : Colors.black54,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 48,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: isDark ? 4 : 8,
                                  color: isDark
                                      ? colorScheme.surface
                                      : Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isDark
                                            ? [
                                                Colors.grey.shade900,
                                                Colors.grey.shade800,
                                              ]
                                            : [
                                                Colors.white,
                                                Colors.blue.shade50,
                                              ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.blue.shade900
                                                      .withOpacity(0.3)
                                                  : Colors.blue
                                                      .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? Colors.blue.shade700
                                                    : Colors.blue
                                                        .withOpacity(0.5),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isDark
                                                      ? Colors.black
                                                          .withOpacity(0.3)
                                                      : Colors.blue
                                                          .withOpacity(0.2),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.support_agent,
                                              size: 54,
                                              color: isDark
                                                  ? Colors.blue.shade300
                                                  : Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'Welcome to Support Chat',
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.blue.shade900
                                                      .withOpacity(0.2)
                                                  : Colors.blue
                                                      .withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: isDark
                                                    ? Colors.blue.shade800
                                                        .withOpacity(0.3)
                                                    : Colors.blue
                                                        .withOpacity(0.1),
                                              ),
                                            ),
                                            child: Text(
                                              'This is a safe and confidential space where you can seek help and guidance. Our AI assistant is here to support you.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: isDark
                                                    ? Colors.grey.shade300
                                                    : Colors.black87,
                                                height: 1.4,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isDark
                                                    ? [
                                                        Colors.blue.shade700,
                                                        Colors.blue.shade900,
                                                      ]
                                                    : [
                                                        Colors.blue,
                                                        Colors.blue.shade700,
                                                      ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isDark
                                                      ? Colors.black
                                                          .withOpacity(0.3)
                                                      : Colors.blue
                                                          .withOpacity(0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: _hideWelcomeCard,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 12,
                                                ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Start Chat',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.arrow_forward),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_showSuggestions)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickResponses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () =>
                                _handleSubmitted(_quickResponses[index]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isDark ? Colors.blue.shade700 : Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: isDark ? 2 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(_quickResponses[index]),
                          ),
                        );
                      },
                    ),
                  ),
                if (_isLoading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? Colors.blue.shade300 : Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Typing...',
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surface : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: _handleSubmitted,
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onTap: () {
                            if (_showSuggestions) {
                              setState(() => _showSuggestions = false);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    Colors.blue.shade700,
                                    Colors.blue.shade900,
                                  ]
                                : [Colors.blue, Colors.blue.shade700],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () =>
                              _handleSubmitted(_messageController.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.isError,
  });
}
