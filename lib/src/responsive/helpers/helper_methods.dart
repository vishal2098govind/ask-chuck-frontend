part of '../responsive.dart';

T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T Function()? desktop,
}) {
  final mediaQuery = MediaQuery.of(context);
  final deviceScreenType = DeviceScreenType.fromMediaQuery(mediaQuery);
  if (deviceScreenType.isDesktop) {
    if (desktop != null) {
      return desktop();
    }
  }
  return mobile;
}

void responsiveCallBack(
  BuildContext context, {
  required void Function() mobile,
  void Function()? tablet,
  void Function()? desktop,
}) {
  final mediaQuery = MediaQuery.of(context);
  final deviceScreenType = DeviceScreenType.fromMediaQuery(mediaQuery);
  if (deviceScreenType.isDesktop) {
    if (desktop != null) return desktop();
  }

  return mobile();
}
