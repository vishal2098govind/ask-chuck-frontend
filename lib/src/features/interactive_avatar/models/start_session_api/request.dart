import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class StartSessionRequest extends AsyncRequest {
  final String sessionId;

  const StartSessionRequest({required this.sessionId})
      : super(baseUrl: "https://api.heygen.com/v1/streaming.start");

  @override
  FutureOr<Map<String, dynamic>?> prepareRequestBody() {
    return {
      "session_id": sessionId,
    };
  }
}
