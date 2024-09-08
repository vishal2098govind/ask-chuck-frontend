part of 'current_user_bloc.dart';

class CurrentUserState extends Equatable {
  final User? currentUser;

  const CurrentUserState({this.currentUser});

  @override
  List<Object?> get props => [currentUser];

  CurrentUserState copyWith({
    User? Function()? currentUser,
  }) {
    return CurrentUserState(
      currentUser: currentUser != null ? currentUser() : this.currentUser,
    );
  }
}
