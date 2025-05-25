import 'package:ask_chuck/src/app/settings_icon_button.dart';
import 'package:ask_chuck/src/features/auth/application/bloc/current_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalAppBar extends StatelessWidget {
  const HorizontalAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Image.asset("assets/icons/AskChuck.png"),
              const Spacer(),
              if (state.currentUser?.email == "anurag@infinative.com" ||
                  state.currentUser?.email == "vishal.govind@infinative.com")
                const SettingsIconButton()
            ],
          ),
        );
      },
    );
  }
}
