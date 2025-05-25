import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';
import 'package:ask_chuck/src/features/chat/models/session_conversation_api/response.dart';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
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

  String _replaceSourcesWithMarkdownLinks(String text) {
    Map<String, String?> sourceLinks = getSourceLinks();

    // Use RegExp to find [SourceX], [X], and [X, Y, ...] tags
    RegExp sourceExp = RegExp(r'\[Source(\d+)\]');
    RegExp multiNumExp = RegExp(r'\[(\d+(?:\s*,\s*\d+)+)\]');
    RegExp numExp = RegExp(r'\[(\d+)\]');
    RegExp numCommaExp = RegExp(r'\[(\d+),\]');

    // First replace [SourceX] tags
    String updatedText = text.replaceAllMapped(sourceExp, (Match match) {
      final sourceKey = '${match.group(0)}';
      final url = sourceLinks[sourceKey];

      if (url != null) {
        return '[[${match.group(0)}]]';
      } else {
        return match.group(0)!;
      }
    });

    // Then replace [X, Y, ...] tags
    updatedText = updatedText.replaceAllMapped(multiNumExp, (Match match) {
      final numbers = match.group(1)!.split(',').map((n) => n.trim());
      return "[${numbers.map((n) {
        final sourceKey = n;
        final url = sourceLinks[sourceKey];
        if (url != null) {
          return '[$n,]';
        } else {
          return n;
        }
      }).join(' , ')}]";
    });

    // Finally replace remaining single [X] tags
    updatedText = updatedText.replaceAllMapped(numExp, (Match match) {
      final sourceKey = '${match.group(1)}';
      final url = sourceLinks[sourceKey];

      if (url != null) {
        return '[[${match.group(1)}]($url)]';
      } else {
        return match.group(0)!;
      }
    });

    return updatedText.replaceAllMapped(numCommaExp, (Match match) {
      final sourceKey = '${match.group(1)}';
      final url = sourceLinks[sourceKey];

      if (url != null) {
        return '[${match.group(1)}]($url)';
      } else {
        return match.group(0)!;
      }
    });
  }

  Map<String, String?> getSourceLinks() {
    final Map<String, String?> sourceLinks = {};
    for (int i = 0; i < widget.chatContext.length; i++) {
      final ctx = widget.chatContext[i];
      final (source, page) = (ctx.metaData?.source, ctx.metaData?.page);
      sourceLinks["${i + 1}"] = "$source${page != null ? "#page=$page" : ""}";
    }
    return sourceLinks;
  }

  Map<String, ChatContext> get indexedSources {
    final Map<String, ChatContext> sourceLinks = {};
    for (int i = 0; i < widget.chatContext.length; i++) {
      final ctx = widget.chatContext[i];
      sourceLinks["${i + 1}"] = ctx;
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
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2DEF9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          widget.humanMessage,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge
                              ?.copyWith(
                                color: const Color(0xFF6F6F6F),
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: 12,
                      child: CustomPaint(
                        painter: ChatBubbleTailPainter(
                          color: const Color(0xFFD9E6FC),
                        ),
                        size: const Size(12, 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: aiMessage,
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                  onTapLink: onTapLink,
                ),
              ),
              const SizedBox(width: 150),
            ],
          ),
          Row(
            children: [
              Expanded(child: SourcesListView(chatContext: widget.chatContext)),
              const SizedBox(width: 150),
            ],
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

class ChatBubbleTailPainter extends CustomPainter {
  final Color color;

  ChatBubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // Draw a downward pointing triangle
    path.moveTo(0, 0);
    path.lineTo((size.width / 2) + 8, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
