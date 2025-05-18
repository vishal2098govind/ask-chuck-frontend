import 'package:ask_chuck/src/features/auth/presentation/widgets/current_user_builder.dart';
import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/interactive_avatar/presentation/screens/heygen_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ask_chuck/src/app/app_navbar.dart';
import 'package:ask_chuck/src/responsive/responsive.dart';

final GlobalKey<ScaffoldState> appScaffoldKey = GlobalKey();

class AppScaffold extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const AppScaffold({super.key, required this.state, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appScaffoldKey,
      drawer: const AppNavbar(),
      body: Stack(
        children: [
          Row(
            children: [
              ResponsiveScreenLayout(
                mobile: (_) => const SizedBox.shrink(),
                desktop: (p0) => const AppNavbar(),
              ),
              Expanded(child: widget.child),
            ],
          ),
          CurrentUserBuilder(
            builder: (context, state) => state.currentUser != null
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: SizedBox(
                      height: isCollapsed
                          ? 250
                          : MediaQuery.of(context).size.height * 0.95,
                      width: isCollapsed
                          ? 250
                          : MediaQuery.of(context).size.width * 0.95,
                      child: Stack(
                        children: [
                          BlocBuilder<ChatBloc, ChatState>(
                            builder: (context, state) {
                              return HeygenRoom(
                                debugMode: false,
                                key: state.heyGenKey,
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isCollapsed = !isCollapsed;
                                });
                              },
                              child: Icon(
                                  isCollapsed
                                      ? Icons.fullscreen
                                      : Icons.fullscreen_exit,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
