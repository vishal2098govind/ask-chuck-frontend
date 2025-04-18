import 'dart:convert';
import 'package:ask_chuck/src/features/chat/models/shared/chat_context.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSourceTile extends StatelessWidget {
  const ImageSourceTile({
    super.key,
    required this.ctx,
  });
  final ChatContext ctx;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .doc("ask_chuck_images/${ctx.metaData?.imageId}")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return InkWell(
              onTap: () {
                final (source, page) = (
                  ctx.metaData?.source,
                  ctx.metaData?.page,
                );
                final uri = Uri.parse(
                  "$source${page != null ? "#page=$page" : ""}#search=${Uri.encodeFull(ctx.pageContent ?? "")}",
                );
                launchUrl(uri);
              },
              child: Image.memory(
                base64Decode(snapshot.data!.get("image_base64")),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        });
  }
}
