import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class CloseSessionRequest extends AsyncRequest {
  final String sessionId;

  const CloseSessionRequest({required this.sessionId})
      : super(baseUrl: "https://api.heygen.com/v1/streaming.stop");

  @override
  FutureOr<Map<String, dynamic>?> prepareRequestBody() {
    return {
      "session_id": sessionId,
    };
  }
}
