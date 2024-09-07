import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class ConverseRequest extends AsyncRequest {
  final String query;
  final String sessionId;
  final String userId;

  const ConverseRequest({
    required this.query,
    required this.sessionId,
    required this.userId,
  }) : super(endpoint: "/converse");

  @override
  FutureOr<Map<String, dynamic>?> prepareRequestQueryParams() {
    return {
      "query": query,
      "session_id": sessionId,
      "user_id": userId,
    };
  }
}
