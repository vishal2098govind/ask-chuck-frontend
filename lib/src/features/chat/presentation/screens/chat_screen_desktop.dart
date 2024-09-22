import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_interface.dart';
import 'package:flutter/material.dart';

class ChatScreenDesktop extends StatelessWidget {
  const ChatScreenDesktop({
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
