import 'package:ask_chuck/src/core/parser.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_history.dart';

class ConverseResponse {
  final String? input;
  final List<ChatHistory> chatHistory;
  final List<ChatContext> context;

  const ConverseResponse({
    required this.input,
    required this.chatHistory,
    required this.context,
  });

  factory ConverseResponse.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ConverseResponse(
          input: parseValueType<String?>(
            map["input"],
            defaultValue: null,
          ),
          chatHistory: parseList(
            map["chat_history"],
            parseItem: (e) => ChatHistory.fromMap(e),
          ),
          context: parseList(
            map["context"],
            parseItem: (e) => ChatContext.fromMap(e),
          ),
        );
    }

    return const ConverseResponse(
      input: null,
      chatHistory: [],
      context: [],
    );
  }
}
