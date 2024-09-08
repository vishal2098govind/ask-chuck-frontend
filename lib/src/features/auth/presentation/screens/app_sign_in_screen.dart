import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as env;

import 'package:ask_chuck/src/router/app_routes.dart';
import 'package:ask_chuck/src/router/router_refresh_listenable.dart';

class AppSignInScreen extends StatefulWidget {
  const AppSignInScreen({
    super.key,
  });

  @override
  State<AppSignInScreen> createState() => _AppSignInScreenState();
}

class _AppSignInScreenState extends State<AppSignInScreen> {
  Object? err;
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed(AppRoute.guestChat.name);
              },
              label: const Text("Ask Chuck as guest"),
              icon: const Icon(Icons.chat),
            ),
            const SizedBox(height: 20),
            isSigningIn
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: isSigningIn
                        ? null
                        : () async {
                            try {
                              final clientId =
                                  env.dotenv.env["GOOGLE_SIGN_IN_CLIENT_ID"];
                              if (clientId == null) return;
                              setState(() {
                                isSigningIn = true;
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

                              await FirebaseAuth.instance
                                  .signInWithCredential(creds);

                              RouterRefreshListenable.instance.refresh();
                            } catch (e) {
                              debugPrint("$e");
                              if (context.mounted) {
                                setState(() {
                                  err = e.toString();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Something went wrong: ${e.toString()}"),
                                  ),
                                );
                              }
                            } finally {
                              setState(() {
                                isSigningIn = false;
                              });
                            }
                          },
                    icon: Image.asset("assets/icons/google_sign_in.png"),
                    label: const Text("Sign in with google"),
                  ),
          ],
        ),
      ),
    );
  }
}
