import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';

class CurrentUserBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    CurrentUserState currentUser,
  ) builder;

  const CurrentUserBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return builder(context, state);
      },
    );
  }
}
