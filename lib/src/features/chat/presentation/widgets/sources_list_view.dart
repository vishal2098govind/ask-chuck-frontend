import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
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
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const ListTile(title: Text("Sources:")),
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: chatContext.length,
              itemBuilder: (context, index) {
                final metaData = chatContext[index].metaData;
                final pageContent = chatContext[index].pageContent;
                if (metaData == null) return const SizedBox.shrink();

                final title = metaData.title;
                final (source, page) = (metaData.source, metaData.page);

                return InkWell(
                  onTap: () async {
                    final uri = Uri.parse(
                      "$source${page != null ? "#page=$page" : ""}#search=${Uri.encodeFull(pageContent ?? "")}",
                    );
                    launchUrl(uri);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    width: 200,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
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
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "$source",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
