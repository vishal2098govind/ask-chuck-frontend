import 'package:ask_chuck/src/app/prompt_editor.dart';
import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SideSheet.left(
          width: MediaQuery.of(context).size.width * 0.4,
          context: context,
          sheetColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return PromptEditor(
                prompt: state.globalPrompt,
              );
            },
          ),
        );
      },
      child: const Icon(Icons.settings, color: Colors.white),
    );
  }
}
