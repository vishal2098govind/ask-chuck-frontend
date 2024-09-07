import 'package:ask_chuck/src/core/parser.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSession {
  final List<SessionConversation> conversations;

  const ChatSession({required this.conversations});

  factory ChatSession.fromCollectionSnapshot(QuerySnapshot? snapshot) {
    final conversations = snapshot?.docs
            .map((e) => SessionConversation.fromSnapshot(e))
            .toList() ??
        [];

    conversations.sort(
      (a, b) => -(a.createdAt ?? DateTime.now())
          .compareTo(b.createdAt ?? DateTime.now()),
    );
    return ChatSession(
      conversations: conversations,
    );
  }
}

class SessionConversation {
  final ChatHistory? aiMessage;
  final ChatHistory? humanMessage;
  final List<ChatContext> context;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SessionConversation({
    required this.aiMessage,
    required this.humanMessage,
    required this.context,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionConversation.fromSnapshot(DocumentSnapshot? doc) {
    final map = doc?.data();

    switch (map) {
      case Map():
        final createdAt = map["created_at"];
        final updatedAt = map["updated_at"];
        return SessionConversation(
          aiMessage: ChatHistory.fromFirebase(map["ai_message"]),
          humanMessage: ChatHistory.fromFirebase(map["human_message"]),
          context: parseList(
            map["context"],
            parseItem: (e) => ChatContext.fromMap(e),
          ),
          createdAt: switch (createdAt) {
            DateTime() => createdAt,
            Timestamp() => createdAt.toDate(),
            _ => null,
          },
          updatedAt: switch (updatedAt) {
            DateTime() => updatedAt,
            Timestamp() => updatedAt.toDate(),
            _ => null,
          },
        );
    }

    return const SessionConversation(
      aiMessage: null,
      humanMessage: null,
      context: [],
      createdAt: null,
      updatedAt: null,
    );
  }
}
