import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Professional floating chat input with smart send/record toggle
class FloatingChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final String hintText;

  const FloatingChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.onMic,
    this.hintText = 'Type a message...',
  });

  @override
  State<FloatingChatInput> createState() => _FloatingChatInputState();
}

class _FloatingChatInputState extends State<FloatingChatInput> {
  bool _hasText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextState);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateTextState() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                // Attach button
                _buildIconButton(
                  icon: Icons.attachment_rounded,
                  color: AppColors.primary,
                  onPressed: widget.onAttach,
                  isDark: isDark,
                ),

                // Input field
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      if (_hasText) {
                        widget.onSend();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),

                // Send/Record button (toggles based on text)
                _buildActionButton(
                  isDark: isDark,
                  hasText: _hasText,
                  onSend: widget.onSend,
                  onMic: widget.onMic,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required bool isDark,
    required bool hasText,
    required VoidCallback onSend,
    VoidCallback? onMic,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: hasText
          ? _buildSendButton(isDark, onSend)
          : _buildMicButton(isDark, onMic),
    );
  }

  Widget _buildSendButton(bool isDark, VoidCallback onSend) {
    return Container(
      key: const ValueKey('send'),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSend,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton(bool isDark, VoidCallback? onMic) {
    return Container(
      key: const ValueKey('mic'),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onMic,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.mic_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
