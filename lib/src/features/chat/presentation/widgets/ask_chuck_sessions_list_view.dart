import 'package:cloud_firestore/cloud_firestore.dart';
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Material(
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
                      IconButton(
                        hoverColor: Colors.white54,
                        splashRadius: 12,
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Delete chat",
                                style: TextStyle(color: Colors.black),
                              ),
                              content: const Text(
                                "Are you sure?",
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            FirebaseFirestore.instance
                                .doc("ask_chuck_sessions/${sessions[index].id}")
                                .delete();
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
