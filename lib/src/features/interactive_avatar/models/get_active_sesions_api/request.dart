import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

class GetActiveSessionsRequest extends AsyncRequest {
  const GetActiveSessionsRequest()
      : super(
          baseUrl: "https://api.heygen.com/v1/streaming.list",
        );
}
