import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/core/async_helpers/async_value.dart';
import 'package:ask_chuck/src/dependencies/dependencies.dart';
import 'package:ask_chuck/src/features/chat/models/ask_chuck_sessions_api/response.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/request.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final StreamSubscription<User?> currentUserStreamSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _askChuckSessionsStreamSubscription;

  ChatBloc() : super(const ChatState()) {
    currentUserStreamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      add(const SetChatSessionId(sessionId: null));
      add(SetChatUserId(userId: user?.uid));
    });

    on<ChatEvent>(
      (event, emit) {
        switch (event) {
          case SetChatSessionId():
            _handleSetChatSessionId(event, emit);
            break;
          case SetChatUserId():
            _handleSetChatUserId(event, emit);
            break;
          case Converse():
            _handleConverse(event, emit);
            break;
          case SetChatState():
            _handleSetCurrentConversation(event, emit);
            break;
        }
      },
    );
  }

  void _handleSetChatSessionId(
    SetChatSessionId event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      sessionId: () => event.sessionId,
      currentConversation: const AsyncNull(),
    ));
  }

  Future<void> _handleSetChatUserId(
    SetChatUserId event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        userId: () => event.userId,
        askChuckSessions: const AskChuckSessions(sessions: []),
      ),
    );
    await _askChuckSessionsStreamSubscription?.cancel();
    if (event.userId == null) {
      return;
    }

    _askChuckSessionsStreamSubscription = FirebaseFirestore.instance
        .collection("/ask_chuck_sessions")
        .where("user_id", isEqualTo: event.userId)
        .snapshots()
        .listen(
      (event) {
        add(
          SetChatState(
            newState: state.copyWith(
              askChuckSessions: AskChuckSessions.fromCollectionSnapshot(event),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleConverse(
    Converse event,
    Emitter<ChatState> emit,
  ) async {
    var (String? sessionId) = (state.sessionId);

    sessionId ??= const Uuid().v6();

    emit(state.copyWith(
      currentConversation: const AsyncLoading(),
      sessionId: () => sessionId,
      currentQuery: () => event.query,
    ));

    final result = await chatRepository.converse(
      ConverseRequest(
        query: event.query,
        sessionId: sessionId,
        userId: event.userId,
      ),
    );

    switch (result) {
      case AsyncSuccessResponse():
        add(
          SetChatState(
            newState: state.copyWith(
              currentConversation: AsyncData(
                data: result.response,
              ),
              currentQuery: () => null,
            ),
          ),
        );
        break;
      case AsyncFailureResponse():
        add(
          SetChatState(
            newState: state.copyWith(
              currentConversation: AsyncError(
                appFailure: result,
              ),
              currentQuery: () => null,
            ),
          ),
        );
        break;
    }
  }

  void _handleSetCurrentConversation(
    SetChatState event,
    Emitter<ChatState> emit,
  ) {
    emit(event.newState);
  }

  @override
  Future<void> close() async {
    await _askChuckSessionsStreamSubscription?.cancel();
    await currentUserStreamSubscription.cancel();
    return super.close();
  }
}
