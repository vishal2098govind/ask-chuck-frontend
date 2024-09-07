import 'package:ask_chuck/src/core/parser.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context_meta_data.dart';

class ChatContext {
  final ChatContextMetaData? metaData;
  final String? pageContent;
  final String? type;

  const ChatContext({
    required this.metaData,
    required this.pageContent,
    required this.type,
  });

  factory ChatContext.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ChatContext(
          metaData: ChatContextMetaData.fromMap(map["metadata"]),
          pageContent: parseValueType<String?>(
            map["page_content"],
            defaultValue: null,
          ),
          type: parseValueType<String?>(
            map["type"],
            defaultValue: null,
          ),
        );
    }

    return const ChatContext(
      metaData: null,
      pageContent: null,
      type: null,
    );
  }
}
