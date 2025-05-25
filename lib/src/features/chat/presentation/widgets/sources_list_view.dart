import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/image_source_tile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SourcesListView extends StatelessWidget {
  const SourcesListView({
    super.key,
    required this.chatContext,
  });

  final List<ChatContext> chatContext;

  @override
  Widget build(BuildContext context) {
    final contextGroups = chatContext.groupBySource().entries.toList();

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.zero,
        textColor: Colors.white,
        title: const Row(
          children: [
            SizedBox(width: 8),
            Text("Sources:"),
          ],
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        childrenPadding: EdgeInsets.zero,
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...contextGroups.map((ctg) {
                          final groupItem = ctg.value.toSet();
                          final metaData = groupItem.isEmpty
                              ? null
                              : ctg.value.first.metaData;
                          if (metaData == null) return const SizedBox.shrink();

                          final title = metaData.title;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white.withOpacity(0.4),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.all(8.0),
                            width: 240,
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$title",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...groupItem.map(
                                  (ctx) {
                                    final (source, page, imageId) = (
                                      ctx.metaData?.source,
                                      ctx.metaData?.page,
                                      ctx.metaData?.imageId
                                    );
                                    if (imageId != null) {
                                      return ImageSourceTile(ctx: ctx);
                                    }

                                    return Column(
                                      children: [
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          hoverColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onTap: () {
                                            final uri = Uri.parse(
                                              "$source${page != null ? "#page=$page" : ""}#search=${Uri.encodeFull(ctx.pageContent ?? "")}",
                                            );
                                            launchUrl(uri);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              "Page #$page, ${ctx.pageContent}...",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
