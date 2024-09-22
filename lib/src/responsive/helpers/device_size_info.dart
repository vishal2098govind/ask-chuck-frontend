part of '../responsive.dart';

class DeviceSizeInfo {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  DeviceSizeInfo({
    required this.deviceScreenType,
    required this.screenSize,
    required this.localWidgetSize,
  });

  bool get isDesktop => deviceScreenType.isDesktop;
  bool get isMobile => deviceScreenType.isMobile;

  @override
  String toString() =>
      'DeviceSizeInfo(deviceScreenType: $deviceScreenType, screenSize: $screenSize, localWidgetSize: $localWidgetSize)';
}
