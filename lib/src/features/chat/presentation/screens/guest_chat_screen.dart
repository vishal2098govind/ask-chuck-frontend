import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_history_list_view.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:ask_chuck/src/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GuestChatScreen extends StatelessWidget {
  const GuestChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(AppRoute.signin.name);
            },
            child: const Text("Sign in"),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: state.sessionId == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  if (state.sessionId != null)
                    const Expanded(child: ChatHistoryListView()),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ChatTextField(),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Ask Chucks may display inaccurate info, including about people, so double-check its responses.",
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
