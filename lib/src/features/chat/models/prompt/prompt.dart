import 'package:ask_chuck/src/core/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Prompt {
  final String? header;
  final String? footer;

  const Prompt({required this.header, required this.footer});

  factory Prompt.fromSnapshot(DocumentSnapshot? doc) {
    final map = doc?.data();

    switch (map) {
      case Map():
        return Prompt(
          header: parseValueType<String?>(
            map["ask_ai_prompt"]?["header"],
            defaultValue: null,
          ),
          footer: parseValueType<String?>(
            map["ask_ai_prompt"]?["footer"],
            defaultValue: null,
          ),
        );
      default:
        return const Prompt(header: null, footer: null);
    }
  }
}
