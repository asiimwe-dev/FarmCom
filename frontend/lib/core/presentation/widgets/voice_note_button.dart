import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VoiceNoteButton extends StatefulWidget {
  final Function(String path) onRecordingComplete;

  const VoiceNoteButton({
    super.key,
    required this.onRecordingComplete,
  });

  @override
  State<VoiceNoteButton> createState() => _VoiceNoteButtonState();
}

class _VoiceNoteButtonState extends State<VoiceNoteButton> {
  bool _isRecording = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      setState(() {
        _isRecording = true;
      });
      // TODO: Implement actual audio recording with record package
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
      setState(() {
        _isRecording = false;
      });
      widget.onRecordingComplete(path);
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startRecording,
      onLongPressUp: _stopRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red : const Color(0xFF2E7D32),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (_isRecording ? Colors.red : const Color(0xFF2E7D32)).withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          _isRecording ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
