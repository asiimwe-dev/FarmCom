import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/modern_chat_bubble.dart';
import 'package:farmlink_ug/core/presentation/widgets/floating_chat_input.dart';
import 'package:farmlink_ug/core/presentation/widgets/offline_indicator.dart';

class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I\'m your FarmLink UG AI Assistant. How can I help you with your farm today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _generateAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('disease') || lowerMessage.contains('sick')) {
      return 'I can help with that. For accurate crop disease identification, please use our AI Quick-Scan feature on the dashboard. It uses specialized computer vision to analyze leaf patterns.\n\nCommon treatments for coffee rust include copper-based fungicides and ensuring proper spacing between plants.';
    }
    if (lowerMessage.contains('price') || lowerMessage.contains('market')) {
      return 'Current market prices:\n• Coffee (kg): 5,500-6,200 UGX\n• Maize (100kg bag): 95,000-110,000 UGX\n• Matooke (bunch): 8,000-12,000 UGX\n\nPrices fluctuate daily. Check Market Pulse for live updates!';
    }
    if (lowerMessage.contains('weather') || lowerMessage.contains('rain')) {
      return 'Based on weather forecasts, expect scattered rains in the next 3-5 days. Perfect timing to prepare your fields. Remember to check soil moisture before irrigation.';
    }
    if (lowerMessage.contains('fertilizer') || lowerMessage.contains('nutrient')) {
      return 'For nutrient deficiency, I recommend:\n• Nitrogen: Apply 2-3 weeks after planting\n• Phosphorus: Essential for root development\n• Potassium: Improves fruit quality\n\nVisit our Field Guide for detailed application methods.';
    }

    return 'I\'m here to help! You can ask me about:\n• Crop diseases & identification\n• Market prices\n• Weather conditions\n• Fertilizer & nutrients\n• Farming tips\n\nWhat would you like to know?';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
        appBar: UIRefinementKit.buildGradientAppBar(
          context: context,
          title: 'FarmLink AI Assistant',
          onLeadingPressed: () => Navigator.of(context).pop(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Chat messages area
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      SpacingConstants.paddingLG,
                      SpacingConstants.paddingLG,
                      SpacingConstants.paddingLG,
                      120, // Extra space for floating input
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return AIChatBubble(
                        text: message.text,
                        isUser: message.isUser,
                        timestamp: message.timestamp,
                      );
                    },
                  ),
                ),
              ],
            ),
            // Floating input at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FloatingChatInput(
                controller: _messageController,
                onSend: _sendMessage,
                onMic: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voice message feature coming soon!')),
                  );
                },
                hintText: 'Ask me anything...',
              ),
            ),
            // Offline indicator
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
