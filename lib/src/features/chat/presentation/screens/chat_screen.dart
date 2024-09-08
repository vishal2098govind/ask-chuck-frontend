import 'package:flutter/material.dart';

import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_interface.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          child: const ChatInterface(),
        ),
      ),
    );
  }
}
