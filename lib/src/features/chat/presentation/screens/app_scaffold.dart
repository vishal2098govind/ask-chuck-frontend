import 'package:ask_chuck/src/app/app_navbar.dart';
import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const AppScaffold({super.key, required this.state, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void didUpdateWidget(covariant AppScaffold oldWidget) {
    BlocProvider.of<CurrentUserBloc>(context).add(
      const FetchCurrentUser(),
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppNavbar(),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
