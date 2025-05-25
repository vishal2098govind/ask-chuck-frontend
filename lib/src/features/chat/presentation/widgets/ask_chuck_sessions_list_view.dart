import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';

class AskChuckSessionsListView extends StatelessWidget {
  const AskChuckSessionsListView({
    super.key,
    this.isExpanded = true,
  });
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, chatState) {
        final sessions = chatState.askChuckSessions.sessions;

        return SliverList.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Material(
              type: MaterialType.transparency,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: Colors.white54,
                selectedTileColor: Colors.white54,
                selected: chatState.sessionId == session.id,
                onTap: () {
                  BlocProvider.of<ChatBloc>(context).add(
                    SetChatSessionId(sessionId: session.id),
                  );
                },
                title: Row(
                  children: [
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        "${sessions[index].sessionName}",
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.delete,
                      size: 16,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
