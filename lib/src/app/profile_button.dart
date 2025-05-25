import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';
import 'package:ask_chuck/src/router/router_refresh_listenable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({
    super.key,
    this.isExpanded = false,
  });
  final bool isExpanded;

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  GlobalKey<PopupMenuButtonState> menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            type: MaterialType.transparency,
            child: PopupMenuButton(
              splashRadius: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minWidth: 200),
              key: menuKey,
              offset: const Offset(10, -80),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () async {
                      menuKey.currentState?.reassemble();
                      await FirebaseAuth.instance.signOut();
                      RouterRefreshListenable.instance.refresh();
                    },
                    child: const ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Icon(Icons.logout),
                    ),
                  ),
                ];
              },
              child: !widget.isExpanded
                  ? const UserAvatar()
                  : ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () {
                        menuKey.currentState?.showButtonMenu();
                      },
                      hoverColor: Colors.white70,
                      leading: const UserAvatar(),
                      title: !widget.isExpanded
                          ? const SizedBox.shrink()
                          : Text("${state.currentUser?.displayName}"),
                      trailing: !widget.isExpanded
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white54,
                            ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFCA91FF),
      child: Text(
        "${FirebaseAuth.instance.currentUser?.displayName?.characters.firstOrNull}",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
