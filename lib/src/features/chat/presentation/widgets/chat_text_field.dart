import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: (query) => _handleChat(context, query),
      decoration: InputDecoration(
        hintText: "Ask anything with Chucks",
        suffixIcon: IconButton(
          onPressed: () {
            _handleChat(context, controller.text);
          },
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }

  void _handleChat(
    BuildContext context,
    String query,
  ) {
    controller.clear();
    BlocProvider.of<ChatBloc>(context).add(
      Converse(
        query: query,
        userId: FirebaseAuth.instance.currentUser?.uid ?? "vishal",
      ),
    );
  }
}
