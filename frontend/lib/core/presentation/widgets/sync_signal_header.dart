import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/connectivity/connectivity_provider.dart';

class SyncSignalHeader extends ConsumerWidget {
  const SyncSignalHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          color: isOnline ? const Color(0xFF2E7D32).withValues(alpha: 0.12) : Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PulseIcon(isOnline: isOnline),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isOnline ? "Live Connection" : "Offline Mode: Actions will sync later",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOnline ? const Color(0xFF2E7D32) : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

class _PulseIcon extends StatefulWidget {
  final bool isOnline;
  const _PulseIcon({
    super.key,
    required this.isOnline,
  });

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOnline) {
      return const Icon(Icons.signal_wifi_off, size: 14, color: Colors.grey);
    }

    return FadeTransition(
      opacity: _controller,
      child: const Icon(Icons.circle, size: 8, color: Color(0xFF2E7D32)),
    );
  }
}
