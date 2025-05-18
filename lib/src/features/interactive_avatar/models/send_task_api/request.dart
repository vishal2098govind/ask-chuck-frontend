import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class SendTaskRequest extends AsyncRequest {
  final String sessionId;
  final String text;

  const SendTaskRequest({required this.sessionId, required this.text})
      : super(baseUrl: "https://api.heygen.com/v1/streaming.task");

  @override
  FutureOr<Map<String, dynamic>?> prepareRequestBody() {
    return {
      "session_id": sessionId,
      "text": text,
      "task_type": "repeat",
    };
  }
}
