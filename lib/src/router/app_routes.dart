enum AppRoute {
  guestChat(
    fullPath: "/guest-chat",
    relativePath: "guest-chat",
    screenTitle: "Chat",
  ),
  chat(
    fullPath: "/chat",
    relativePath: "chat",
    screenTitle: "Chat",
  ),
  signin(
    fullPath: "/signin",
    relativePath: "signin",
    screenTitle: "Sign In",
  );

  final String fullPath;
  final String relativePath;
  final String screenTitle;

  const AppRoute({
    required this.fullPath,
    required this.relativePath,
    required this.screenTitle,
  });
}
