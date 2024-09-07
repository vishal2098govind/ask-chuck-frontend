import 'package:ask_chuck/src/core/parser.dart';

class ChatHistory {
  final String? content;
  final String? type;

  const ChatHistory({
    required this.content,
    required this.type,
  });

  bool get isAiMessage => type == "ai";

  factory ChatHistory.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ChatHistory(
          content: parseValueType<String?>(
            map["content"],
            defaultValue: null,
          ),
          type: parseValueType<String?>(
            map["type"],
            defaultValue: null,
          ),
        );
    }

    return const ChatHistory(content: null, type: null);
  }

  factory ChatHistory.fromFirebase(Object? map) {
    switch (map) {
      case Map():
        final data = map["data"];
        return ChatHistory(
          content: switch (data) {
            Map() => parseValueType<String?>(
                data["content"],
                defaultValue: null,
              ),
            _ => null,
          },
          type: parseValueType<String?>(
            map["type"],
            defaultValue: null,
          ),
        );
    }

    return const ChatHistory(content: null, type: null);
  }
}
