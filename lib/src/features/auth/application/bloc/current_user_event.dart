part of 'current_user_bloc.dart';

sealed class CurrentUserEvent {
  const CurrentUserEvent();
}

class FetchCurrentUser extends CurrentUserEvent {
  const FetchCurrentUser();
}
