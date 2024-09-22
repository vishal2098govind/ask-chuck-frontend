import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_history_list_view.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:ask_chuck/src/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInterface extends StatelessWidget {
  const ChatInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ResponsiveScreenLayout(
                desktop: (context) {
                  return const SizedBox(height: 100);
                },
                mobile: (p0) => const SizedBox.shrink(),
              ),
              if (state.sessionId != null)
                const Expanded(child: ChatHistoryListView()),
              const SizedBox(height: 8),
              const ChatTextField(),
              const SizedBox(height: 8),
              Text(
                "Ask Chuck may display inaccurate info, including about people, so double-check its responses.",
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              ResponsiveScreenLayout(
                desktop: (context) {
                  return const SizedBox(height: 80);
                },
                mobile: (p0) => const SizedBox(height: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
