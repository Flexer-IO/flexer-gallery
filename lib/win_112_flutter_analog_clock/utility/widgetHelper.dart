import 'package:flutter/material.dart';

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getDimention(BuildContext context, double unit) {
  if (fullWidth(context) <= 360.0) {
    return unit / 1.3;
  } else {
    return unit;
  }
}

ThemeData customTheme(BuildContext context) {
  final ThemeData base = Theme.of(context);
  final bool isLight = base.brightness == Brightness.light;

  if (isLight) {
    return base.copyWith(
      primaryColor: const Color(0xff5E6086),
      highlightColor: const Color(0xff909abb),
      colorScheme: base.colorScheme.copyWith(
        secondary: Colors.red,
        background: const Color(0xfff1f3f6),
      ),
    );
  } else {
    return base.copyWith(
      primaryColor: const Color(0xFFD2E3FC),
      highlightColor: const Color(0xFF4285F4),
      colorScheme: base.colorScheme.copyWith(
        secondary: const Color(0xFF8AB4F8),
        background: const Color(0xFFe3edf7),
      ),
    );
  }
}

BoxDecoration decoration(BuildContext context,
    {BoxShape shape = BoxShape.circle}) {
  return BoxDecoration(
    boxShadow: <BoxShadow>[
      BoxShadow(
          blurRadius: 20,
          offset: const Offset(10, 10),
          color: const Color(0xff3753aa).withAlpha(25),
          spreadRadius: 5),
      BoxShadow(
          blurRadius: 20,
          offset: const Offset(-10, -10),
          color: const Color(0xaaffffff),
          spreadRadius: 5),
      BoxShadow(
          blurRadius: 4,
          offset: const Offset(2, 2),
          color: const Color(0xaaffffff).withAlpha(125),
          spreadRadius: 1),
    ],
    color: const Color(0xfff1f3f6),
    shape: shape,
  );
}