import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';

/// Modern chat input area with enhanced styling and features
class ModernChatInputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final String hintText;
  final int maxLines;

  const ModernChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.onMic,
    this.hintText = 'Type a message...',
    this.maxLines = 4,
  });

  @override
  State<ModernChatInputArea> createState() => _ModernChatInputAreaState();
}

class _ModernChatInputAreaState extends State<ModernChatInputArea> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextState);
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

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attach/Add button
          AnimatedOpacity(
            opacity: _hasText ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: _hasText ? 0.85 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                onPressed: widget.onAttach,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                color: AppColors.primary,
                splashRadius: 24,
                tooltip: 'Attach media',
              ),
            ),
          ),
          // Mic button (optional)
          if (widget.onMic != null)
            AnimatedOpacity(
              opacity: _hasText ? 0.6 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                scale: _hasText ? 0.85 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2D7F4B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: widget.onMic,
                    icon: const Icon(Icons.mic_none_rounded, size: 20),
                    color: Colors.white,
                    splashRadius: 24,
                    tooltip: 'Voice message',
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          // Input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : AppColors.grey50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _hasText
                      ? AppColors.primary
                      : (isDark ? Colors.white12 : AppColors.grey200),
                  width: _hasText ? 1.5 : 1,
                ),
                boxShadow: _hasText
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: widget.controller,
                maxLines: 1,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.grey900,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : AppColors.grey500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: _hasText
                      ? Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: IconButton(
                            onPressed: () {
                              widget.controller.clear();
                              _updateTextState();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: AppColors.grey500,
                            splashRadius: 20,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _hasText
                    ? [AppColors.primary, const Color(0xFF2D7F4B)]
                    : [AppColors.grey400, AppColors.grey400],
              ),
              shape: BoxShape.circle,
              boxShadow: _hasText
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _hasText ? widget.onSend : null,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedRotation(
                    turns: _hasText ? 0 : 0.25,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _hasText ? Icons.send_rounded : Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
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

/// Alternative compact input area
class CompactChatInputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;

  const CompactChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Message...',
  });

  @override
  State<CompactChatInputArea> createState() => _CompactChatInputAreaState();
}

class _CompactChatInputAreaState extends State<CompactChatInputArea> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextState);
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

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white12 : AppColors.grey200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : AppColors.grey50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white12 : AppColors.grey200,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                maxLines: 1,
                minLines: 1,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.grey900,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : AppColors.grey500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _hasText ? widget.onSend : null,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _hasText
                      ? [AppColors.primary, const Color(0xFF2D7F4B)]
                      : [AppColors.grey400, AppColors.grey400],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
