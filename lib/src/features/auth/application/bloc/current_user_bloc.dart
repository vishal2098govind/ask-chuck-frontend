import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  CurrentUserBloc() : super(const CurrentUserState()) {
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
}
