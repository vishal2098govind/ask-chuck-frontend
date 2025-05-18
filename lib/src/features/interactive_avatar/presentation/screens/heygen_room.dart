import 'dart:async';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/dependencies/dependencies.dart';
import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/ask_ai_text_field.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/close_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/get_active_sesions_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:ask_chuck/src/core/async_helpers/async_value.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/response.dart';
import 'package:intl/intl.dart';
import 'package:livekit_client/livekit_client.dart';

class HeygenRoom extends StatefulWidget {
  const HeygenRoom({super.key, this.debugMode = true});
  final bool debugMode;

  @override
  State<HeygenRoom> createState() => HeygenRoomState();
}

class HeygenRoomState extends State<HeygenRoom> {
  TextEditingController taskController = TextEditingController();

  AsyncValue<CreateNewSessionResponse> createSessionValue = const AsyncNull();
  AsyncValue<StartSessionResponse> startSessionValue = const AsyncNull();
  AsyncValue<SendTaskResponse> sendTaskValue = const AsyncNull();

  void reset() {
    createSessionValue = const AsyncNull();
    startSessionValue = const AsyncNull();
    sendTaskValue = const AsyncNull();
    _logs.clear();
    room = null;
    setState(() {});
  }

  // logging
  final List<String> _logs = [];

  void log(String message) {
    final ts = DateFormat.Hms().format(DateTime.now());
    _logs.add("[$ts] $message");

    setState(() {});
  }

  // LiveKit
  Room? room;
  RemoteParticipant? participant;

  VideoTrack? get videoTrack =>
      participant?.videoTrackPublications.firstOrNull?.track;
  AudioTrack? get audioTrack =>
      participant?.audioTrackPublications.firstOrNull?.track;

  @override
  void initState() {
    super.initState();
    createSession();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  // create session
  Future<void> createSession() async {
    setState(() {
      createSessionValue = const AsyncLoading();
    });

    final activeSessions = await heygenRepo.getActiveSessions(
      const GetActiveSessionsRequest(),
    );
    switch (activeSessions) {
      case AsyncSuccessResponse():
        for (var activeSession in activeSessions.response.activeSessions) {
          final sessionId = activeSession.sessionId;
          if (sessionId == null) continue;
          await heygenRepo.closeSession(
            CloseSessionRequest(sessionId: sessionId),
          );
        }
        break;
      default:
    }

    final session = await heygenRepo.createNewSession(
      const CreateNewSessionRequest(),
    );
    switch (session) {
      case AsyncSuccessResponse():
        log(
          '''CREATE_SESSION: Session created 
          session_id: ${session.response.sessionId}, 
          url:${session.response.url}, 
          token:${session.response.accessToken}''',
        );
        setState(() {
          createSessionValue = AsyncData(data: session.response);
        });
        startSession(session.response);
      case AsyncFailureResponse():
        log('''CREATE_SESSION: Failed to create new session
        error: ${session.failureMessage}''');
        setState(() {
          createSessionValue = AsyncError(appFailure: session);
        });
    }
  }

  // start session
  Future<void> startSession(CreateNewSessionResponse session) async {
    setState(() {
      startSessionValue = const AsyncLoading();
    });
    final result = await heygenRepo.startSession(
      StartSessionRequest(sessionId: session.sessionId ?? ""),
    );
    switch (result) {
      case AsyncSuccessResponse():
        log(
          '''START_SESSION: Session started 
          status: ${result.response.status}''',
        );
        setState(() {
          startSessionValue = AsyncData(data: result.response);
        });
        setupLivekitRoom();
      case AsyncFailureResponse():
        log('''START_SESSION: Failed to create new session
        error: ${result.failureMessage}''');
        setState(() {
          startSessionValue = AsyncError(appFailure: result);
        });
    }
  }

  // send task
  Future<void> sendTask(String text) async {
    if (sendTaskValue is AsyncLoading) return;
    setState(() {
      sendTaskValue = const AsyncLoading();
    });
    final sessionId = switch (createSessionValue) {
      AsyncData(:final data) => data.sessionId,
      _ => null,
    };
    if (sessionId == null) return;

    final result = await heygenRepo.sendTask(
      SendTaskRequest(sessionId: sessionId, text: text),
    );

    switch (result) {
      case AsyncSuccessResponse():
        log(
          '''SEND_TASK: Task sent
          taskId: ${result.response.taskId}
          duration_ms: ${result.response.durationMs}''',
        );
        setState(() {
          sendTaskValue = AsyncData(data: result.response);
        });
      case AsyncFailureResponse():
        log('''SEND_TASK: Failed to create new session
        error: ${result.failureMessage}''');
        setState(() {
          sendTaskValue = AsyncError(appFailure: result);
        });
    }
  }

  // Setup LiveKit Room
  Future<void> setupLivekitRoom() async {
    try {
      final url = switch (createSessionValue) {
        AsyncData(:final data) => data.url,
        _ => null,
      };
      final accessToken = switch (createSessionValue) {
        AsyncData(:final data) => data.accessToken,
        _ => null,
      };
      if (url == null || accessToken == null) return;

      room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      final listener = room?.createListener();

      await room?.prepareConnection(url, accessToken);

      await room?.connect(url, accessToken);

      log("room connected");

      listener?.on<TrackSubscribedEvent>(_onTrackSubscribed);
      listener?.on<TrackUnsubscribedEvent>(_onTrackUnsubscribed);
    } catch (e) {
      log("SETUP_LIVEKIT_ROOM: error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            if (widget.debugMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:
                        createSessionValue is! AsyncData ? createSession : null,
                    child: const Text("Start session"),
                  ),
                  OutlinedButton(
                    onPressed: createSessionValue is AsyncData ? () {} : null,
                    child: const Text("Close session"),
                  ),
                  ElevatedButton(
                    onPressed: reset,
                    child: const Text("Reset"),
                  ),
                ],
              ),
            if (widget.debugMode) const SizedBox(height: 20),
            if (widget.debugMode)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: taskController,
                      decoration: InputDecoration(
                        hintText: "Enter text for avatar to speak",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => sendTask(taskController.text),
                    child: const Text("Repeat"),
                  ),
                ],
              ),
            if (widget.debugMode) const SizedBox(height: 10),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: videoTrack == null
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: VideoTrackRenderer(
                                videoTrack!,
                                fit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                                renderMode: VideoRenderMode.auto,
                              ),
                            ),
                            AskAITextField(
                              handleTranscript: (query) {
                                BlocProvider.of<ChatBloc>(context).add(
                                  Converse(
                                    query: query,
                                    userId: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "vishal",
                                    handleAnswer: sendTask,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ),
            if (widget.debugMode)
              SizedBox(
                height: 200,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Text(_logs[index]);
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  FutureOr<void> _onTrackSubscribed(TrackSubscribedEvent event) {
    participant = event.participant;
    log("TrackSubscribedEvent: participant: $participant");
    setState(() {});
  }

  FutureOr<void> _onTrackUnsubscribed(TrackUnsubscribedEvent event) {}
}
