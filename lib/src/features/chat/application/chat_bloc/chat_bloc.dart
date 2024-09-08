import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/core/async_helpers/async_value.dart';
import 'package:ask_chuck/src/dependencies/dependencies.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/request.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
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
    emit(state.copyWith(sessionId: () => event.sessionId));
  }

  void _handleSetChatUserId(
    SetChatUserId event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(userId: () => event.userId));
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
}
