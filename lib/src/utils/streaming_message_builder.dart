import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class StreamingMessageBuilder extends StatelessWidget {
  const StreamingMessageBuilder({
    super.key,
    required this.words,
    this.messageBuilder,
    this.onStreamingComplete,
  });

  final String words;
  final void Function()? onStreamingComplete;
  final Widget Function(BuildContext context, String message)? messageBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      isRepeatingAnimation: false,
      repeatForever: false,
      animatedTexts: [
        TypewriterAnimatedText(
          words,
          speed: const Duration(milliseconds: 20),
        )
      ],
    );
    // return AnimatedBuilder(
    //   animation: controller,
    //   builder: (context, child) {
    //     String message = controller.isCompleted ? widget.words : "";
    //     final stream = widget.words.split(" ");
    //     if (!controller.isCompleted) {
    //       for (int i = 0; i < stream.length; i++) {
    //         final ellapsedMs =
    //             controller.lastElapsedDuration?.inMilliseconds ?? 0;
    //         if (i * 200 <= ellapsedMs) {
    //           message += "${stream[i]} ";
    //         }
    //       }
    //     }

    //     return widget.messageBuilder?.call(context, message) ?? Text(message);
    //   },
    // );
  }
}
