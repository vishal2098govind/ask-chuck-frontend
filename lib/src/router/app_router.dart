import 'dart:async';

import 'package:ask_chuck/src/features/chat/presentation/screens/app_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ask_chuck/src/features/auth/presentation/screens/app_sign_in_screen.dart';
import 'package:ask_chuck/src/features/chat/presentation/screens/chat_screen.dart';
import 'package:ask_chuck/src/router/app_routes.dart';
import 'package:ask_chuck/src/router/router_refresh_listenable.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: AppRoute.guestChat.fullPath,
    redirect: _handleRedirect,
    refreshListenable: RouterRefreshListenable.instance,
    routes: [
      GoRoute(
        path: AppRoute.signin.fullPath,
        name: AppRoute.signin.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: Title(
            title: AppRoute.signin.screenTitle,
            color: Theme.of(context).colorScheme.primary,
            child: const AppSignInScreen(),
          ),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(
          state: state,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoute.guestChat.fullPath,
            name: AppRoute.guestChat.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: Title(
                title: AppRoute.guestChat.screenTitle,
                color: Theme.of(context).colorScheme.primary,
                child: const ChatScreen(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoute.chat.fullPath,
            name: AppRoute.chat.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: Title(
                title: AppRoute.chat.screenTitle,
                color: Theme.of(context).colorScheme.primary,
                child: const ChatScreen(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

FutureOr<String?> _handleRedirect(
  BuildContext context,
  GoRouterState state,
) {
  final isSignedIn = FirebaseAuth.instance.currentUser != null;

  bool isRoutingToAuthenticatedRoute =
      state.matchedLocation != AppRoute.guestChat.fullPath &&
          state.matchedLocation != AppRoute.signin.fullPath;

  if (isSignedIn) {
    if (state.matchedLocation == AppRoute.guestChat.fullPath ||
        state.matchedLocation == AppRoute.signin.fullPath) {
      return AppRoute.chat.fullPath;
    }
    return null;
  }

  if (isRoutingToAuthenticatedRoute) {
    return AppRoute.guestChat.fullPath;
  }

  return null;
}
