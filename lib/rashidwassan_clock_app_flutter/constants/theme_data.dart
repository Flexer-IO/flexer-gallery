import 'package:flutter/material.dart';

class CustomColors {
  static const Color primaryTextColor = Colors.white;
  static const Color dividerColor = Colors.white54;
  static const Color pageBackgroundColor = Color(0xFF2D2F41);
  static const Color menuBackgroundColor = Color(0xFF242634);

  static const Color clockBG = Color(0xFF444974);
  static const Color clockOutline = Color(0xFFEAECFF);
  static const Color secHandColor = Color(0xFFFFA726);
  static const Color minHandStatColor = Color(0xFF748EF6);
  static const Color minHandEndColor = Color(0xFF77DDFF);
  static const Color hourHandStatColor = Color(0xFFC279FB);
  static const Color hourHandEndColor = Color(0xFFEA74AB);
}

class GradientColors {
  final List<Color> colors;
  const GradientColors(this.colors);

  static const List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static const List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static const List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static const List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static const List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static const List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}