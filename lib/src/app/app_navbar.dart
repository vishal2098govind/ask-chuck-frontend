import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/ask_chuck_sessions_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ask_chuck/src/features/auth/presentation/widgets/current_user_builder.dart';
import 'package:ask_chuck/src/router/app_routes.dart';
import 'package:ask_chuck/src/router/router_refresh_listenable.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.white,
            width: 0.2,
          ),
        ),
      ),
      constraints: const BoxConstraints(
        maxWidth: 250,
      ),
      child: CurrentUserBuilder(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ListTile(
                          title: Text(
                            "Ask Chucks",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      if (state.currentUser != null)
                        SliverToBoxAdapter(
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(const SetChatSessionId(sessionId: null));
                            },
                            child: const Text("Start new thread"),
                          ),
                        ),
                      if (state.currentUser == null)
                        SliverToBoxAdapter(
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed(AppRoute.signin.name);
                            },
                            child: const Text("Sign in"),
                          ),
                        ),
                      if (state.currentUser != null)
                        const AskChuckSessionsListView(),
                    ],
                  ),
                ),
              ),
              if (state.currentUser != null) ...[
                const Divider(height: 0),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    RouterRefreshListenable.instance.refresh();
                  },
                  child: const Text("Sign out"),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}
