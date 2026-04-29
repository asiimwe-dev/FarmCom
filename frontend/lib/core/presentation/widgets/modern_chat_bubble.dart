import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';

/// Modern chat bubble with enhanced styling and animations
class ModernChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String senderName;
  final String? senderRole;
  final DateTime? timestamp;
  final bool isExpert;
  final VoidCallback? onLongPress;

  const ModernChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.senderName,
    this.senderRole,
    this.timestamp,
    this.isExpert = false,
    this.onLongPress,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = _formatTime(timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender info for non-user messages
          if (!isUser && senderRole != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Row(
                children: [
                  Text(
                    senderName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.grey900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (isExpert) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.tertiary, AppColors.tertiarySoft],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EXPERT',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          // Message bubble
          GestureDetector(
            onLongPress: onLongPress,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // User message: gradient primary
                gradient: isUser
                    ? const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2D7F4B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser
                    ? null
                    : (isDark
                        ? (isExpert ? AppColors.tertiary.withValues(alpha: 0.15) : const Color(0xFF2C2C2C))
                        : (isExpert ? AppColors.tertiary.withValues(alpha: 0.08) : Colors.white)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 6),
                  bottomRight: Radius.circular(isUser ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: isUser ? 12 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (isDark
                              ? (isExpert ? AppColors.tertiary : Colors.white)
                              : (isExpert ? AppColors.tertiary : AppColors.grey900)),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.7)
                            : (isDark
                                ? Colors.white38
                                : (isExpert ? AppColors.tertiary.withValues(alpha: 0.6) : AppColors.grey500)),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AI Chat Bubble with special styling
class AIChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final VoidCallback? onLongPress;

  const AIChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.onLongPress,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = _formatTime(timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI Avatar for AI messages
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF2D7F4B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
          ],
          // Message bubble
          GestureDetector(
            onLongPress: onLongPress,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2D7F4B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser
                    ? null
                    : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F5F2)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 6),
                  bottomRight: Radius.circular(isUser ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : (isDark ? Colors.white : AppColors.grey900),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.7)
                            : (isDark ? Colors.white38 : AppColors.grey500),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
