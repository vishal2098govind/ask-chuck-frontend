import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';

class AskChuckSessionsListView extends StatelessWidget {
  const AskChuckSessionsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, chatState) {
        final sessions = chatState.askChuckSessions.sessions;

        return SliverList.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              selected: chatState.sessionId == session.id,
              onTap: () {
                BlocProvider.of<ChatBloc>(context).add(
                  SetChatSessionId(sessionId: session.id),
                );
              },
              title: Text(
                "${sessions[index].sessionName}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        );
      },
    );
  }
}
