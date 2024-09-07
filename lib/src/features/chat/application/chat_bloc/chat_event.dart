part of 'chat_bloc.dart';

sealed class ChatEvent {
  const ChatEvent();
}

class SetChatSessionId extends ChatEvent {
  final String? sessionId;

  const SetChatSessionId({required this.sessionId});
}

class SetChatUserId extends ChatEvent {
  final String? userId;

  const SetChatUserId({required this.userId});
}

class Converse extends ChatEvent {
  final String query;

  const Converse({
    required this.query,
  });
}

class SetChatState extends ChatEvent {
  final ChatState newState;

  const SetChatState({required this.newState});
}
