import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/models/session_conversation_api/response.dart';

class ChatHistoryListView extends StatelessWidget {
  const ChatHistoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final sessionId = state.sessionId;

        if (sessionId == null) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("/ask_chuck_sessions/$sessionId/conversations")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chatSession = ChatSession.fromCollectionSnapshot(
              snapshot.data,
            );

            List<Widget> widgets = [];
            if (state.currentQuery != null) {
              widgets.add(
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListTile(
                    title: Text("${state.currentQuery}"),
                    subtitle: Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: [
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 4, top: 4),
                            color: Colors.white,
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 4, top: 4),
                            color: Colors.white,
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 4, top: 4),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            for (var chat in chatSession.conversations) {
              widgets.add(
                ListTile(
                  title: Text("${chat.humanMessage?.content}"),
                  subtitle: Text("${chat.aiMessage?.content}"),
                ),
              );
            }

            // final currentConversation = state.currentConversation;

            return ListView.builder(
              reverse: true,
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                return widgets[index];
              },
            );
          },
        );
      },
    );
  }
}
