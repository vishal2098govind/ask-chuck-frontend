import 'package:ask_chuck/src/core/parser.dart';

class CreateNewSessionResponse {
  final int? code;
  final String? message;

  // The WebSocket URL for accessing the LiveKit room (e.g., wss://heygen-feapbkvq.livekit.cloud).
  final String? url;

  // HeyGen session id
  final String? sessionId;

  // The access token required to authenticate and join the LiveKit room.
  final String? accessToken;

  const CreateNewSessionResponse({
    required this.code,
    required this.message,
    required this.url,
    required this.sessionId,
    required this.accessToken,
  });

  factory CreateNewSessionResponse.fromMap(Map<String, dynamic> map) {
    return CreateNewSessionResponse(
      code: parseValueType(map["code"], defaultValue: null),
      message: parseValueType(map["message"], defaultValue: null),
      url: parseValueType(map["data"]?["url"], defaultValue: null),
      sessionId: parseValueType(map["data"]?["session_id"], defaultValue: null),
      accessToken:
          parseValueType(map["data"]?["access_token"], defaultValue: null),
    );
  }
}
