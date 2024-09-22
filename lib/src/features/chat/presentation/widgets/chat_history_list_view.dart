import 'package:ask_chuck/src/core/async_helpers/async_value.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/chat_conversation_tile.dart';
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
        final currentConversation = switch (state.currentConversation) {
          AsyncData(data: final data) => data,
          _ => null,
        };

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
              currentConversationId: currentConversation?.conversationId,
            );

            List<Widget> widgets = [];
            if (state.currentQuery != null) {
              widgets.add(
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${state.currentQuery}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
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
                    ],
                  ),
                ),
              );
            }

            final conversations = chatSession.conversations.where(
              (e) => e.conversationId != currentConversation?.conversationId,
            );

            if (currentConversation?.conversationId != null) {
              widgets.add(
                ChatConversationTile.fromConverseResponse(
                  currentConversation: currentConversation!,
                ),
              );
            }

            for (var i = 0; i < conversations.length; i++) {
              final chat = chatSession.conversations[i];

              widgets.add(
                ChatConversationTile.fromSessionConversation(chat: chat),
              );
            }

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
