import 'package:ask_chuck/src/core/parser.dart';

class SendTaskResponse {
  final double? durationMs;
  final String? taskId;

  const SendTaskResponse({required this.durationMs, required this.taskId});

  factory SendTaskResponse.fromMap(Map<String, dynamic> map) {
    return SendTaskResponse(
      durationMs: parseValueType(map["duration_ms"], defaultValue: null),
      taskId: parseValueType(map["task_id"], defaultValue: null),
    );
  }
}
