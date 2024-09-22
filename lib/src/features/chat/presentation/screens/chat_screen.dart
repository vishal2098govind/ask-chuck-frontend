import 'package:flutter/material.dart';

import 'package:ask_chuck/src/features/chat/presentation/screens/chat_screen_desktop.dart';
import 'package:ask_chuck/src/features/chat/presentation/screens/chat_screen_mobile.dart';
import 'package:ask_chuck/src/responsive/responsive.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenLayout(
      desktop: (_) => const ChatScreenDesktop(),
      mobile: (_) => const ChatScreenMobile(),
    );
  }
}
