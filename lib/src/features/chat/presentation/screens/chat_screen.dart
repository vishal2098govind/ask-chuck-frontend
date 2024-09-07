import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ask_chuck/src/router/router_refresh_listenable.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              RouterRefreshListenable.instance.refresh();
            },
            child: const Text("Sign out"),
          )
        ],
      ),
    );
  }
}
