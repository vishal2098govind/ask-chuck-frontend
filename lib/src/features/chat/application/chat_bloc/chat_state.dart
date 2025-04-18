part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final AsyncValue<ConverseResponse> currentConversation;
  final AskChuckSessions askChuckSessions;
  final Prompt? globalPrompt;
  final String? currentQuery;
  final String? sessionId;
  final String? userId;

  const ChatState({
    this.globalPrompt,
    this.currentConversation = const AsyncNull(),
    // this.sessionId = "test_pinecone_session_2",
    this.askChuckSessions = const AskChuckSessions(sessions: []),
    this.sessionId,
    this.currentQuery,
    this.userId,
  });

  @override
  List<Object?> get props => [
        globalPrompt,
        currentConversation,
        sessionId,
        currentQuery,
        askChuckSessions,
        userId,
      ];

  ChatState copyWith({
    AsyncValue<ConverseResponse>? currentConversation,
    AskChuckSessions? askChuckSessions,
    Prompt? Function()? globalPrompt,
    String? Function()? currentQuery,
    String? Function()? sessionId,
    String? Function()? userId,
  }) {
    return ChatState(
      askChuckSessions: askChuckSessions ?? this.askChuckSessions,
      currentConversation: currentConversation ?? this.currentConversation,
      currentQuery: currentQuery != null ? currentQuery() : this.currentQuery,
      sessionId: sessionId != null ? sessionId() : this.sessionId,
      globalPrompt: globalPrompt != null ? globalPrompt() : this.globalPrompt,
      userId: userId != null ? userId() : this.userId,
    );
  }
}
