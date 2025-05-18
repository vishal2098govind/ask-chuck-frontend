import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:microphone/microphone.dart';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/services/deepgram_service.dart';

class AskAITextField extends StatefulWidget {
  const AskAITextField({
    super.key,
    this.handleTranscript,
    this.handleFailure,
  });
  final void Function(String)? handleTranscript;
  final void Function()? handleFailure;

  @override
  State<AskAITextField> createState() => _AskAITextFieldState();
}

class _AskAITextFieldState extends State<AskAITextField> {
  AudioState? audioState;
  MicrophoneRecorder? _recorder;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _recorder = MicrophoneRecorder()..init();
  }

  @override
  void dispose() {
    _recorder?.dispose();
    super.dispose();
  }

  void handleAudioState(AudioState? state) {
    setState(() {
      if (audioState == null) {
        // Starts recording
        audioState = AudioState.recording;
        _recorder?.start();
        // Finished recording
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        _recorder?.stop();
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        _audioPlayer = AudioPlayer();
        final url = _recorder?.value.recording?.url;
        if (url != null) {
          _audioPlayer?.setUrl(url).then((_) {
            _audioPlayer?.play().then((_) {
              setState(() => audioState = AudioState.play);
            });
          });
        }

        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        _audioPlayer?.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => handleAudioState(audioState),
          icon: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: getIcon(audioState),
            ),
          ),
        ),
        if (audioState == AudioState.play || audioState == AudioState.stop)
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.replay),
          ),
        TextButton.icon(
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.auto_awesome),
          onPressed:
              audioState == AudioState.play || audioState == AudioState.stop
                  ? askChatAIAction
                  : null,
          label: const Text("Ask AI"),
        )
      ],
    );
  }

  void askChatAIAction() async {
    final bytes = await _recorder?.toBytes();
    if (bytes == null) return;
    final transcript = await DeepgramService().transcribeAudio(bytes);
    switch (transcript) {
      case AsyncSuccessResponse():
        widget.handleTranscript?.call(transcript.response);
      case AsyncFailureResponse():
        widget.handleFailure?.call();
    }
  }

  void reset() async {
    setState(() {
      audioState = null;
      _recorder?.dispose();
      _recorder = MicrophoneRecorder()..init();
    });
  }

  Widget getIcon(AudioState? state) {
    switch (state) {
      case AudioState.play:
        return const Icon(Icons.play_arrow);
      case AudioState.stop:
        return const Icon(Icons.stop);
      case AudioState.recording:
        return const Icon(Icons.mic, color: Colors.redAccent);
      default:
        return const Icon(Icons.mic);
    }
  }
}

enum AudioState { recording, stop, play }
