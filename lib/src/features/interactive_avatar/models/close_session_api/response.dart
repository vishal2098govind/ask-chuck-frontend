import 'package:ask_chuck/src/core/parser.dart';

class CloseSessionResponse {
  final String? status;

  const CloseSessionResponse({required this.status});

  factory CloseSessionResponse.fromMap(Object? map) {
    switch (map) {
      case Map():
        return CloseSessionResponse(
          status: parseValueType(map["status"], defaultValue: null),
        );
      default:
        return const CloseSessionResponse(status: null);
    }
  }
}
