import 'package:flutter/material.dart';

class ClockPalette {
  const ClockPalette(this.colors);
  final List<Color> colors;

  factory ClockPalette.fromJson(List<dynamic> json) =>
      ClockPalette(json.map((c) => Color(int.tryParse(c)!)).toList());

  Color get bg => colors.isNotEmpty ? colors.first : const Color(0xFF000000);
  Color get ring => colors.length > 1 ? colors[1] : bg;
  Color get text => colors.length > 2 ? colors[2] : accent;
  Color get accent => colors.isNotEmpty ? colors.last : const Color(0xFFFFFFFF);
  bool get isDark => bg.computeLuminance() < 0.15;
}

enum ClockPaletteMode { all, dark, light }
