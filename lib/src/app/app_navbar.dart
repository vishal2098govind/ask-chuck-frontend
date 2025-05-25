import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ask_chuck/src/app/profile_button.dart';
import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';
import 'package:ask_chuck/src/features/auth/presentation/screens/app_sign_in_screen.dart';
import 'package:ask_chuck/src/features/chat/application/chat_bloc/chat_bloc.dart';
import 'package:ask_chuck/src/features/chat/presentation/widgets/ask_chuck_sessions_list_view.dart';

class AppNavbar extends StatefulWidget {
  const AppNavbar({super.key});

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF312350),
      ),
      constraints: BoxConstraints(
        maxWidth: isExpanded ? 250 : 60,
      ),
      child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.currentUser != null)
                Align(
                  alignment:
                      !isExpanded ? Alignment.center : Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: const Icon(
                      Icons.view_sidebar_rounded,
                      color: Color(0xFFCA91FF),
                    ),
                    color: Colors.white,
                  ),
                ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    if (state.currentUser != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: !isExpanded
                              ? InkWell(
                                  onTap: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        const SetChatSessionId(
                                            sessionId: null));
                                  },
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFCA91FF),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("New chat"),
                                  leading: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<ChatBloc>(context).add(
                                          const SetChatSessionId(
                                              sessionId: null));
                                    },
                                    icon: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFCA91FF),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8.0)),
                    if (state.currentUser != null && isExpanded)
                      const AskChuckSessionsListView(),
                    if (state.currentUser != null && !isExpanded)
                      SliverToBoxAdapter(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            icon: const Icon(
                              Icons.chat_bubble,
                              color: Color(0xFFCA91FF),
                            )),
                      ),
                  ],
                ),
              ),
              if (state.currentUser != null) ...[
                const Divider(height: 0),
                const SizedBox(height: 16),
                ProfileButton(isExpanded: isExpanded),
                const SizedBox(height: 16),
              ],
              if (state.currentUser == null) ...[
                const AppSignInButton(),
                const SizedBox(height: 32),
              ],
              // FutureBuilder(
              //   future: PackageInfo.fromPlatform(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const SizedBox.shrink();
              //     }

              //     return Text("v${snapshot.data?.version}");
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
