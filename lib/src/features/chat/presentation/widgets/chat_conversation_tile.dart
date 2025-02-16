import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/utils/streaming_message_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:ask_chuck/src/features/chat/models/session_conversation_api/response.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/sources_list_view.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String _replaceSourcesWithMarkdownLinks(String text) {
    Map<String, String?> sourceLinks = getSourceLinks();

    // Use a RegExp to find all [SourceX] tags
    RegExp exp = RegExp(r'\[Source(\d+)\]');

    // Replace each [SourceX] tag with a Markdown link
    return text.replaceAllMapped(exp, (Match match) {
      final sourceKey = 'Source${match.group(1)}';
      final url = sourceLinks[sourceKey];

      if (url != null) {
        return '[[${match.group(1)}]]($url)'; // Create Markdown link
      } else {
        return match.group(0)!; // Return original tag if URL not found
      }
    });
  }

  Map<String, String?> getSourceLinks() {
    final Map<String, String?> sourceLinks = {};
    for (int i = 0; i < widget.chatContext.length; i++) {
      final ctx = widget.chatContext[i];
      final (source, page) = (ctx.metaData?.source, ctx.metaData?.page);
      sourceLinks["Source${i + 1}"] =
          "$source${page != null ? "#page=$page" : ""}";
    }
    return sourceLinks;
  }

  Map<String, ChatContext> get indexedSources {
    final Map<String, ChatContext> sourceLinks = {};
    for (int i = 0; i < widget.chatContext.length; i++) {
      final ctx = widget.chatContext[i];
      sourceLinks["[${i + 1}]"] = ctx;
    }
    return sourceLinks;
  }

  @override
  Widget build(BuildContext context) {
    final aiMessage = _replaceSourcesWithMarkdownLinks(widget.aiMessage);
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
              data: aiMessage,
              styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
              onTapLink: onTapLink,
            )
          else
            StreamingMessageBuilder(
              onStreamingComplete: () {
                setState(() {
                  stream = false;
                });
              },
              key: ValueKey(widget.conversationId),
              words: aiMessage,
              messageBuilder: (context, message) {
                return Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: message,
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                  onTapLink: onTapLink,
                );
              },
            ),
        ],
      ),
    );
  }

  void onTapLink(String text, String? url, String? title) {
    if (url != null) {
      final ctx = indexedSources[text];
      if (ctx != null) {
        final (source, page) = (ctx.metaData?.source, ctx.metaData?.page);
        final uri = Uri.parse(
          "$source${page != null ? "#page=$page" : ""}",
        );
        launchUrl(uri);
      }
    }
  }
}
