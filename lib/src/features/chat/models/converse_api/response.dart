import 'package:ask_chuck/src/core/parser.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_history.dart';

class ConverseResponse {
  final String? input;
  final String? conversationId;
  final List<ChatHistory> chatHistory;
  final String? answer;
  final List<ChatContext> context;

  const ConverseResponse({
    required this.input,
    required this.answer,
    required this.chatHistory,
    required this.context,
    required this.conversationId,
  });

  factory ConverseResponse.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ConverseResponse(
          input: parseValueType<String?>(
            map["input"],
            defaultValue: null,
          ),
          answer: parseValueType<String?>(
            map["answer"],
            defaultValue: null,
          ),
          conversationId: parseValueType<String?>(
            map["conversation"],
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
      conversationId: null,
      answer: null,
      input: null,
      chatHistory: [],
      context: [],
    );
  }
}
