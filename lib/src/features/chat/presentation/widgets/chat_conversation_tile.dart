import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/utils/streaming_message_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:ask_chuck/src/features/chat/models/session_conversation_api/response.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/sources_list_view.dart';

class ChatConversationTile extends StatefulWidget {
  ChatConversationTile.fromSessionConversation({
    super.key,
    this.stream = false,
    required SessionConversation chat,
  })  : aiMessage = "${chat.aiMessage?.content}",
        humanMessage = "${chat.humanMessage?.content}",
        conversationId = chat.conversationId,
        chatContext = chat.context;

  ChatConversationTile.fromConverseResponse({
    super.key,
    required ConverseResponse currentConversation,
  })  : aiMessage = "${currentConversation.answer}",
        humanMessage = "${currentConversation.input}",
        conversationId = "${currentConversation.conversationId}",
        chatContext = currentConversation.context,
        stream = true;

  final bool stream;
  final String aiMessage;
  final String humanMessage;
  final String conversationId;
  final List<ChatContext> chatContext;

  @override
  State<ChatConversationTile> createState() => _ChatConversationTileState();
}

class _ChatConversationTileState extends State<ChatConversationTile> {
  late bool stream;

  @override
  void initState() {
    stream = widget.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.humanMessage,
            style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SourcesListView(chatContext: widget.chatContext),
          if (!stream)
            Markdown(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              data: widget.aiMessage,
              styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
            )
          else
            StreamingMessageBuilder(
              onStreamingComplete: () {
                setState(() {
                  stream = false;
                });
              },
              key: ValueKey(widget.conversationId),
              words: widget.aiMessage,
              messageBuilder: (context, message) {
                return Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: message,
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                );
              },
            ),
        ],
      ),
    );
  }
}
