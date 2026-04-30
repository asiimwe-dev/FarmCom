import 'package:flutter/material.dart';

/// Enhanced IconButton with accessibility support
/// Use this instead of raw Icon() + IconButton() for better UX
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final Color? color;
  final double size;
  final bool enabled;

  const AccessibleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.color,
    this.size = 24,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        label: tooltip,
        button: true,
        enabled: enabled,
        onTap: enabled ? onPressed : null,
        child: IconButton(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, size: size, color: color),
          tooltip: tooltip,
        ),
      ),
    );
  }
}

/// Enhanced Icon with semantic label and tooltip
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final double size;
  final String? tooltip;

  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final child = Icon(icon, color: color, size: size);
    
    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: Semantics(
          label: label,
          child: child,
        ),
      );
    }
    
    return Semantics(
      label: label,
      child: child,
    );
  }
}
