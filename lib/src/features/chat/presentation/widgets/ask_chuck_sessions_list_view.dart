import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/models/ask_chuck_sessions_api/response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AskChuckSessionsListView extends StatelessWidget {
  const AskChuckSessionsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("/ask_chuck_sessions")
            .where("user_id",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "vishal")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          final sessions =
              AskChuckSessions.fromCollectionSnapshot(snapshot.data).sessions;

          return SliverList.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return BlocBuilder<ChatBloc, ChatState>(
                builder: (context, chatState) {
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
        });
  }
}
