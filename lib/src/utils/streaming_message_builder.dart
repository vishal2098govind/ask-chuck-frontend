import 'package:flutter/material.dart';

class StreamingMessageBuilder extends StatefulWidget {
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
  State<StreamingMessageBuilder> createState() =>
      _StreamingMessageBuilderState();
}

class _StreamingMessageBuilderState extends State<StreamingMessageBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.words.split(" ").length * 200,
      ),
    );

    controller.forward();
    controller.addListener(
      () {
        if (controller.isCompleted) {
          widget.onStreamingComplete?.call();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        String message = controller.isCompleted ? widget.words : "";
        final stream = widget.words.split(" ");
        if (!controller.isCompleted) {
          for (int i = 0; i < stream.length; i++) {
            final ellapsedMs =
                controller.lastElapsedDuration?.inMilliseconds ?? 0;
            if (i * 200 <= ellapsedMs) {
              message += "${stream[i]} ";
            }
          }
        }

        return widget.messageBuilder?.call(context, message) ?? Text(message);
      },
    );
  }
}
