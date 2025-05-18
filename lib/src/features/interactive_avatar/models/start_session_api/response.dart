import 'package:ask_chuck/src/core/parser.dart';

class StartSessionResponse {
  final String? status;

  const StartSessionResponse({required this.status});

  factory StartSessionResponse.fromMap(Map<String, dynamic> map) {
    return StartSessionResponse(
      status: parseValueType(map["status"], defaultValue: null),
    );
  }
}
