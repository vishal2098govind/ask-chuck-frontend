import 'package:ask_chuck/src/core/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AskChuckSessions {
  final List<AskChuckSession> sessions;

  const AskChuckSessions({
    required this.sessions,
  });

  factory AskChuckSessions.fromCollectionSnapshot(QuerySnapshot? snapshot) {
    final sessions =
        snapshot?.docs.map((e) => AskChuckSession.fromSnapshot(e)).toList() ??
            [];

    sessions.sort(
      (a, b) => -(a.createdAt ?? DateTime.now())
          .compareTo(b.createdAt ?? DateTime.now()),
    );
    return AskChuckSessions(
      sessions: sessions,
    );
  }
}

class AskChuckSession {
  final String? sessionName;
  final String? id;
  final DateTime? createdAt;

  const AskChuckSession({
    required this.sessionName,
    required this.id,
    required this.createdAt,
  });

  factory AskChuckSession.fromSnapshot(DocumentSnapshot? doc) {
    final map = doc?.data();

    switch (map) {
      case Map():
        final createdAt = map["created_at"];
        return AskChuckSession(
          id: doc?.id,
          sessionName: parseValueType<String?>(
            map["session_name"] ?? doc?.id,
            defaultValue: null,
          ),
          createdAt: switch (createdAt) {
            DateTime() => createdAt,
            Timestamp() => createdAt.toDate(),
            _ => null,
          },
        );
    }

    return const AskChuckSession(
      sessionName: null,
      id: null,
      createdAt: null,
    );
  }
}
