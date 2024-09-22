part of '../responsive.dart';

enum DeviceScreenType {
  mobile,
  desktop;

  factory DeviceScreenType.fromMediaQuery(MediaQueryData mediaQuery) {
    double deviceWidth = mediaQuery.size.width;
    if (deviceWidth > 950) {
      return DeviceScreenType.desktop;
    }

    return DeviceScreenType.mobile;
  }

  bool get isDesktop => this == DeviceScreenType.desktop;
  bool get isMobile => this == DeviceScreenType.mobile;
}
