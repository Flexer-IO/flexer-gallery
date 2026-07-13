import 'package:flutter/painting.dart';

class ThemeColor {
  final List<Color> gradient;
  final Color backgroundColor;
  final Color toggleButtonColor;
  final Color toggleBackgroundColor;
  final Color textColor;
  final List<BoxShadow> shadow;

  ThemeColor({
    required this.gradient,
    required this.backgroundColor,
    required this.toggleBackgroundColor,
    required this.toggleButtonColor,
    required this.textColor,
    required this.shadow,
  });
}