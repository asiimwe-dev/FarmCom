import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/connectivity/connectivity_provider.dart';

class FloatingConnectionStatus extends ConsumerWidget {
  const FloatingConnectionStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isOnline ? 0 : 40,
        color: Colors.red.shade600,
        child: isOnline
            ? const SizedBox.shrink()
            : SafeArea(
                bottom: false,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.signal_wifi_off, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        'Offline Mode - Actions will sync when online',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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

class OnlineIndicator extends ConsumerWidget {
  const OnlineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Positioned(
      top: 8,
      right: 16,
      child: Row(
        children: [
          if (isOnline) ...[
            _PulseIcon(),
            const SizedBox(width: 4),
            Text(
              'Online',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ] else ...[
            const Icon(Icons.signal_wifi_off, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'Offline',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PulseIcon extends StatefulWidget {
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
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.shade700,
        ),
      ),
    );
  }
}
