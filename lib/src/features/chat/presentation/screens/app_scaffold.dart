import 'package:flutter/material.dart';
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
      body: Row(
        children: [
          ResponsiveScreenLayout(
            mobile: (_) => const SizedBox.shrink(),
            desktop: (_) => const AppNavbar(),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
