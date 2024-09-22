part of '../responsive.dart';

class ResponsiveScreenLayout extends StatelessWidget {
  const ResponsiveScreenLayout({
    super.key,
    required this.mobile,
    this.desktop,
  });
  final Widget Function(DeviceSizeInfo) mobile;
  final Widget Function(DeviceSizeInfo)? desktop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceSizeInfo) {
        if (deviceSizeInfo.isDesktop) {
          return desktop?.call(deviceSizeInfo) ?? mobile(deviceSizeInfo);
        }
        return mobile(deviceSizeInfo);
      },
    );
  }
}
