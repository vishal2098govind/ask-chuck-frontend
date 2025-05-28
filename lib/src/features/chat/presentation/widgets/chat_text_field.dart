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
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: state.sessionId != null
                ? const BorderRadius.all(Radius.circular(10))
                : BorderRadius.circular(8),
            gradient: state.sessionId != null
                ? null
                : const LinearGradient(
                    colors: [
                      Color(0xFFFF76FF),
                      Color(0xFFFFE100),
                      Color(0xFF00FFA6),
                      Color(0xFF4068E1),
                      Color(0xFFFFE100),
                    ],
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: (query) => _handleChat(context, query),
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: state.sessionId != null
                      ? const BorderRadius.all(Radius.circular(10))
                      : BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 0),
                ),
                contentPadding: const EdgeInsets.only(left: 24),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0),
                  borderRadius: state.sessionId != null
                      ? const BorderRadius.all(Radius.circular(10))
                      : BorderRadius.circular(8),
                ),
                hintText: "Ask anything about Chuck Owen’s Work",
                hintStyle: const TextStyle(
                  letterSpacing: 0.1,
                ),
                suffixIcon: IconButton(
                  onPressed: () => _handleChat(context, controller.text),
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
