import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_interface.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/horizontal_app_bar.dart';
import 'package:flutter/material.dart';

class ChatScreenDesktop extends StatelessWidget {
  const ChatScreenDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/icons/gradient.png",
            fit: BoxFit.fitWidth,
          ),
          Column(
            children: [
              const HorizontalAppBar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                    ),
                    child: const ChatInterface(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
