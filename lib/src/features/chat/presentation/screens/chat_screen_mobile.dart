import 'package:ask_chuck/src/features/chat/presentation/screens/app_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_interface.dart';

class ChatScreenMobile extends StatelessWidget {
  const ChatScreenMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            appScaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
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
