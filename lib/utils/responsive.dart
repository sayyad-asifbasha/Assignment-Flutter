import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;

bool isTablet(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;
}

bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;

double responsivePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= AppBreakpoints.desktop) return 32;
  if (width >= AppBreakpoints.tablet) return 24;
  return 12;
}

int gridColumnsForProducts(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 1600) return 5;
  if (width >= 1200) return 4;
  if (width >= 900) return 3;
  if (width >= 600) return 2;
  return 1;
}

Widget maxWidthConstrained({required Widget child, double maxWidth = 1000}) {
  if (kIsWeb) {
    return child;
  }
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
