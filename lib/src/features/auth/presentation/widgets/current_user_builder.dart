import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';

class CurrentUserBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    CurrentUserState currentUser,
  ) builder;

  const CurrentUserBuilder({super.key, required this.builder});

  @override
  State<CurrentUserBuilder> createState() => _CurrentUserBuilderState();
}

class _CurrentUserBuilderState extends State<CurrentUserBuilder> {
  @override
  void initState() {
    BlocProvider.of<CurrentUserBloc>(context).add(
      const FetchCurrentUser(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return widget.builder(context, state);
      },
    );
  }
}
