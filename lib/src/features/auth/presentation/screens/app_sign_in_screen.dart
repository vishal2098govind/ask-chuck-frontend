import 'package:ask_chuck/src/core/async_helpers/async_value.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as env;

import 'package:ask_chuck/src/router/router_refresh_listenable.dart';

class AppSignInButton extends StatefulWidget {
  const AppSignInButton({
    super.key,
    this.handleSignIn,
    this.isExpanded = false,
  });
  final void Function()? handleSignIn;
  final bool isExpanded;

  @override
  State<AppSignInButton> createState() => _AppSignInButtonState();
}

class _AppSignInButtonState extends State<AppSignInButton> {
  Object? err;
  AsyncValue isSigningIn = const AsyncNull();

  @override
  Widget build(BuildContext context) {
    if (!widget.isExpanded) {
      return IconButton(
        onPressed: isSigningIn is AsyncLoading ? null : signIn,
        icon: isSigningIn is AsyncLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const GoogleSignInImage(),
      );
    }

    return ElevatedButton.icon(
      onPressed: isSigningIn is AsyncLoading
          ? null
          : () async {
              await signIn();
            },
      icon: const GoogleSignInImage(),
      label: !widget.isExpanded
          ? const SizedBox.shrink()
          : isSigningIn is AsyncNull
              ? const Text("Sign in with google")
              : const CircularProgressIndicator(),
    );
  }

  Future<void> signIn() async {
    try {
      final clientId = env.dotenv.env["GOOGLE_SIGN_IN_CLIENT_ID"];
      if (clientId == null) return;
      setState(() {
        isSigningIn = const AsyncLoading();
      });
      final account = await GoogleSignIn(
        clientId: clientId,
        scopes: ["email"],
      ).signIn();
      final auth = await account?.authentication;
      final creds = GoogleAuthProvider.credential(
        idToken: auth?.idToken,
        accessToken: auth?.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(creds);

      RouterRefreshListenable.instance.refresh();
      widget.handleSignIn?.call();
    } catch (e) {
      debugPrint("$e");
      if (context.mounted) {
        setState(() {
          err = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${e.toString()}"),
          ),
        );
      }
    } finally {
      setState(() {
        isSigningIn = const AsyncNull();
      });
    }
  }
}

class GoogleSignInImage extends StatelessWidget {
  const GoogleSignInImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/icons/google_sign_in.png");
  }
}
