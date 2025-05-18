import 'package:ask_chuck/src/core/parser.dart';

class GetActiveSessionsResponse {
  final List<ActiveSession> activeSessions;

  const GetActiveSessionsResponse({required this.activeSessions});

  factory GetActiveSessionsResponse.fromMap(Map<String, dynamic> map) {
    return GetActiveSessionsResponse(
      activeSessions: parseList(
        map["data"]?["sessions"],
        parseItem: ActiveSession.fromMap,
      ),
    );
  }
}

class ActiveSession {
  final String? sessionId;
  final String? status;

  const ActiveSession({required this.sessionId, required this.status});

  factory ActiveSession.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ActiveSession(
          sessionId: parseValueType(map["session_id"], defaultValue: null),
          status: parseValueType(map["session_id"], defaultValue: null),
        );
      default:
        return const ActiveSession(sessionId: null, status: null);
    }
  }
}
