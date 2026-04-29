# Modern Chat UI Components Documentation

## Overview
FarmCom now features a completely redesigned chat interface with modern, production-ready chat bubbles and input areas. Both AI Chat and Community Chat have been upgraded with professional styling, animations, and enhanced user experience.

## Components

### 1. ModernChatBubble
Professional chat bubble component for community and multi-user conversations.

**Features:**
- Gradient user messages (green primary color)
- Distinct styling for expert vs regular users
- Expert badge with gradient
- Time display for each message
- Sender name and role information
- Long-press support for future actions
- Dark mode support
- Smooth animations

**Usage:**
```dart
ModernChatBubble(
  text: 'This is my message',
  isUser: true,
  senderName: 'John Doe',
  senderRole: 'Farmer',
  timestamp: DateTime.now(),
  isExpert: false,
  onLongPress: () {
    // Handle long press
  },
)
```

**Styling Details:**
- User messages: Gradient from `AppColors.primary` to `Color(0xFF2D7F4B)`
- AI messages: `const Color(0xFFF0F5F2)` (light) / `Color(0xFF2C2C2C)` (dark)
- Expert messages: Tertiary color with reduced opacity
- Bubble border radius: 20px (top), 4px-20px (bottom, depending on sender)
- Shadow: Dynamic, stronger for user messages

### 2. AIChatBubble
Specialized chat bubble for AI conversations with distinct styling.

**Features:**
- Gradient AI avatar with icon
- Gradient user messages
- Clean, spacious design
- Optimized for long AI responses
- Professional appearance

**Usage:**
```dart
AIChatBubble(
  text: 'How can I help you with your farm?',
  isUser: false,
  timestamp: DateTime.now(),
  onLongPress: () {
    // Handle long press
  },
)
```

**Styling Details:**
- AI avatar: 32x32 gradient circle with `Icons.smart_toy_rounded`
- AI response background: Light green (`0xFFF0F5F2`) for light mode
- User message: Full gradient with rounded corners
- Avatar shadow: Blue-green gradient shadow

### 3. ModernChatInputArea
Advanced input area with animations and multiple action buttons.

**Features:**
- Animated send button (changes color/state based on text)
- Attach media button
- Voice message button with gradient
- Clear text button
- Text field with border animation
- Focus state indication
- Smooth transitions

**Usage:**
```dart
ModernChatInputArea(
  controller: messageController,
  onSend: () {
    print('Sending: ${messageController.text}');
  },
  onAttach: () {
    // Handle media attachment
  },
  onMic: () {
    // Handle voice message
  },
  hintText: 'Ask me anything...',
  maxLines: 4,
)
```

**Features:**
- Border animates to primary color when focused
- Send button disabled (greyed) when no text
- Gradient send button with shadow when text present
- Smooth scale animations for all buttons
- Clear (X) button appears when text is present
- All interactive elements have haptic feedback ready

### 4. CompactChatInputArea
Lightweight input area for simpler use cases.

**Features:**
- Single-line input
- Compact design
- Essential buttons only (send, attach)
- Lower vertical footprint

**Usage:**
```dart
CompactChatInputArea(
  controller: messageController,
  onSend: _sendMessage,
  hintText: 'Message...',
)
```

## Integration

### AI Chat Page
File: `lib/features/ai_chat/presentation/pages/ai_chat_page.dart`

The AI Chat page now uses `AIChatBubble` with `ModernChatInputArea`:

```dart
ListView.builder(
  controller: _scrollController,
  padding: const EdgeInsets.all(20),
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
ModernChatInputArea(
  controller: _messageController,
  onSend: _sendMessage,
  onMic: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice feature coming soon!')),
    );
  },
  hintText: 'Ask me anything...',
),
```

### Community Chat Page
File: `lib/features/community/presentation/pages/community_chat_page.dart`

The Community Chat page uses `ModernChatBubble` with `ModernChatInputArea`:

```dart
ListView.builder(
  controller: _scrollController,
  padding: const EdgeInsets.all(20),
  itemCount: _messages.length,
  itemBuilder: (context, index) {
    final message = _messages[index];
    return ModernChatBubble(
      text: message['text'],
      isUser: message['isMe'],
      senderName: message['user'],
      senderRole: message['role'],
      timestamp: _parseTime(message['time']),
      isExpert: message['role'] == 'Expert',
    );
  },
),
ModernChatInputArea(
  controller: _messageController,
  onSend: _sendMessage,
  onAttach: () { /* ... */ },
  onMic: () { /* ... */ },
  hintText: 'Share with community...',
),
```

## Styling Reference

### Colors Used
- **Primary**: `AppColors.primary` (Green: #2D7F4B)
- **Accent**: `Color(0xFF2D7F4B)` (Darker green)
- **Light Mode Background**: `Color(0xFFF0F5F2)` (Light green)
- **Dark Mode Background**: `Color(0xFF2C2C2C)` (Dark grey)
- **Expert Badge**: `AppColors.tertiary` (with gradient)

### Typography
- **Message Text**: 14px, weight: 500, lineHeight: 1.5
- **Sender Name**: 12px, weight: 700, letterSpacing: 0.3
- **Time**: 11px, weight: 600, letterSpacing: 0.3
- **Expert Badge**: 8px, weight: 900, letterSpacing: 0.5

### Spacing
- **Bubble Padding**: 16px horizontal, 12px vertical
- **Message Margin Bottom**: 16px
- **Input Area Padding**: 12px (with safe area bottom)
- **Sender Info Margin**: 6px (bottom)

### Shadows
- **Bubble Shadow**: Blur 10px, offset 0,2
- **User Message Shadow**: Strong (uses primary color with 0.3 alpha)
- **AI Message Shadow**: Soft (uses black with 0.05-0.2 alpha)
- **Send Button Shadow**: Strong when enabled (primary color, 0.4 alpha)

## Dark Mode Support

All components include full dark mode support:

### Background Colors
- **Light**: White (`Colors.white`)
- **Dark**: `Color(0xFF1E1E1E)` for main, `Color(0xFF2C2C2C)` for secondary

### Text Colors
- **Light Mode**: `AppColors.grey900` (near black)
- **Dark Mode**: `Colors.white` or `Colors.white60`/`Colors.white38`

### Border Colors
- **Light**: `AppColors.grey200`
- **Dark**: `Colors.white12`

## Animation Details

### Send Button
- **States**: 
  - Disabled: Grey, no shadow
  - Enabled: Gradient with shadow
- **Animations**:
  - Color transition: 300ms
  - Scale: Smooth when state changes
  - Rotation: Can be customized

### Input Field
- **Border Animation**: 300ms smooth transition
- **Color Change**: Primary color when focused
- **Shadow**: Appears when has text

### Clear Button
- **Appearance**: Slides in when text present
- **Animation**: 300ms opacity + scale

## Accessibility

All components include:
- Proper semantic labels via `tooltip`
- Color contrast compliant with WCAG
- Touch targets min 48x48px
- Keyboard support for input

## Future Enhancements

1. **Message Reactions**: Add emoji reactions support
2. **Message Search**: Implement searchable chat history
3. **Message Editing**: Allow editing of sent messages
4. **Message Deletion**: Swipe-to-delete gesture
5. **Typing Indicators**: Show "X is typing" state
6. **Read Receipts**: Show message delivery status
7. **Pinned Messages**: Highlight important messages
8. **Reply Functionality**: Quote/reply to specific messages

## Performance Considerations

1. **ListView.builder**: Efficiently renders large chat histories
2. **AnimatedContainer**: Uses implicit animations for smooth transitions
3. **Gradient Rendering**: GPU-accelerated on modern devices
4. **Text Scaling**: Respects system text scale settings
5. **Memory**: No cached message builds, fresh render each time

## Browser & Device Compatibility

- ✅ Android 7.0+
- ✅ iOS 12+
- ✅ Web (Flutter Web)
- ✅ Tablets (responsive)
- ✅ Foldable devices (tested on Samsung Z Fold)

## Example Implementation

### Complete AI Chat Screen
```dart
class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return AIChatBubble(
                  text: _messages[index].text,
                  isUser: _messages[index].isUser,
                  timestamp: _messages[index].timestamp,
                );
              },
            ),
          ),
          ModernChatInputArea(
            controller: _messageController,
            onSend: _sendMessage,
            hintText: 'Ask me anything...',
          ),
        ],
      ),
    );
  }
}
```

## Troubleshooting

### Issue: Bubbles not showing gradient
**Solution**: Ensure `AppColors` is properly imported and colors are defined

### Issue: Input area doesn't respond
**Solution**: Check that `TextEditingController` is properly initialized and disposed

### Issue: Dark mode text not visible
**Solution**: Verify `Theme.of(context).brightness` is correctly reading system theme

### Issue: Animations feel laggy
**Solution**: Ensure device has sufficient resources; check for performance bottlenecks in ListView

## Version Information
- Created: April 29, 2026
- FarmCom Version: 1.0+
- Flutter: 3.0+
- Dart: 2.17+
