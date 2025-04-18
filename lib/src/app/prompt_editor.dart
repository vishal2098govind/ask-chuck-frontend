import 'package:ask_chuck/src/features/chat/models/prompt/prompt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class PromptEditor extends StatefulWidget {
  const PromptEditor({super.key, this.prompt});
  final Prompt? prompt;

  @override
  State<PromptEditor> createState() => _PromptEditorState();
}

class _PromptEditorState extends State<PromptEditor> {
  late Prompt? prompt = widget.prompt;

  late final headerController = TextEditingController(
    text: prompt?.header ?? "",
  );

  late final footerController = TextEditingController(
    text: prompt?.footer ?? "",
  );

  PromptMode editingMode = PromptMode.viewing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prompt",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                ),
                SegmentedButton(
                  showSelectedIcon: false,
                  onSelectionChanged: (item) {
                    setState(() {
                      editingMode =
                          item.isEmpty ? PromptMode.viewing : item.first;
                    });
                  },
                  segments: [
                    ...PromptMode.values.map(
                      (e) => ButtonSegment(
                        value: e,
                        label: Text(e.displayText),
                        enabled: true,
                      ),
                    ),
                  ],
                  selected: {
                    editingMode,
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (editingMode == PromptMode.editing)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Header:"),
                          MarkdownField(controller: headerController),
                          const Text("""
      <charles_owen_works>
      {context}
      </charles_owen_works>
                      """),
                          const Text("Footer:"),
                          MarkdownField(controller: footerController),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .doc(
                          "global_settings/prompt_settings",
                        )
                            .update({
                          "ask_ai_prompt.header": headerController.text,
                          "ask_ai_prompt.footer": footerController.text,
                        });
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Publish"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  """
      ${headerController.text}
      
      <charles_owen_works>
      {context}
      </charles_owen_works>
      
      ${footerController.text}
                """,
                  // styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum PromptMode {
  editing(displayText: "Edit"),
  viewing(displayText: "Preview");

  final String displayText;

  const PromptMode({required this.displayText});
}
