part of '../responsive.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    DeviceSizeInfo sizingInfo,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSizeInfo = DeviceSizeInfo(
          deviceScreenType: DeviceScreenType.fromMediaQuery(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize: Size(constraints.maxWidth, constraints.maxHeight),
        );
        return builder(context, deviceSizeInfo);
      },
    );
  }
}
