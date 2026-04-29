import 'package:flutter/material.dart';

class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final double size;
  final bool enabled;
  final Color? color;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = 24,
    this.enabled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        onPressed: enabled ? onPressed : null,
        tooltip: semanticLabel,
      ),
    );
  }
}

class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? semanticLabel;
  final TextOverflow overflow;
  final int? maxLines;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.semanticLabel,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      child: Text(
        text,
        style: style,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}

class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool enabled;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Semantics(
        enabled: enabled,
        button: true,
        onTap: enabled ? onPressed : null,
        label: label,
        child: ElevatedButton.icon(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon),
          label: Text(label),
        ),
      );
    }

    return Semantics(
      enabled: enabled,
      button: true,
      onTap: enabled ? onPressed : null,
      label: label,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: Text(label),
      ),
    );
  }
}

// Semantic container for better screen reader support
class AccessibleContainer extends StatelessWidget {
  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool enabled;

  const AccessibleContainer({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }
}

// Focus management helper
class FocusableWidget extends StatefulWidget {
  final Widget child;
  final FocusNode? focusNode;
  final VoidCallback? onFocusChanged;

  const FocusableWidget({
    super.key,
    required this.child,
    this.focusNode,
    this.onFocusChanged,
  });

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    widget.onFocusChanged?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _internalFocusNode,
      onKey: (node, event) {
        // Handle keyboard navigation if needed
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}
