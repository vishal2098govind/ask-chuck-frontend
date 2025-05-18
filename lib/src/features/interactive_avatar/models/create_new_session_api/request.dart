import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class CreateNewSessionRequest extends AsyncRequest {
  const CreateNewSessionRequest()
      : super(baseUrl: "https://api.heygen.com/v1/streaming.new");

  @override
  FutureOr<Map<String, dynamic>?> prepareRequestBody() {
    return {
      "quality": "medium",
      "voice": {"rate": 1},
      "video_encoding": "VP8",
      "disable_idle_timeout": false,
      "version": "v2",
    };
  }
}
