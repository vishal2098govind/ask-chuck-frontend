import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  late final StreamSubscription<User?> currentUserStreamSubscription;

  CurrentUserBloc() : super(const CurrentUserState()) {
    currentUserStreamSubscription = FirebaseAuth.instance
        .authStateChanges()
        .listen((_) => add(const FetchCurrentUser()));

    on<CurrentUserEvent>((event, emit) {
      switch (event) {
        case FetchCurrentUser():
          _handleFetchCurrentUser(event, emit);
          break;
      }
    });
  }

  void _handleFetchCurrentUser(
    FetchCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) {
    emit(
      state.copyWith(
        currentUser: () => FirebaseAuth.instance.currentUser,
      ),
    );
  }

  @override
  Future<void> close() async {
    await currentUserStreamSubscription.cancel();
    return super.close();
  }
}
