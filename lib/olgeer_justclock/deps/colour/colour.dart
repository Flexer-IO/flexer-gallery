library colour;

import 'package:flutter/material.dart';

/// An immutable 32 bit color value in any format (normal, hex, rgb, argb, rgbo).
///
///
/// Here are some ways it could be constructed:
///
/// ```dart
/// Colour c = const Colour(0xFF42A5F5);
/// Colour c = const Colour(0xFF42A5F5, 0.5);
/// Colour c = const Colour('42A5F5');
/// Colour c = const Colour('42A5F5', 0.5);
/// Colour c = const Colour('#42A5F5');
/// Colour c = const Colour('42a5f5');
/// Colour c = const Colour('#42a5f5', 0.8);
/// Colour c = const Colour(255, 255, 255); // RGB
/// Colour c = const Colour(255, 255, 255, 255); // ARGB
/// Colour c = const Colour(255, 255, 255, 0.5); // RGBO
/// ```
///
class Colour extends Color {
  Colour(dynamic color, [dynamic x, dynamic y, dynamic z])
      : super(getColor(color, x, y, z));

  /// get an immutable 32 bit color value from dynamic parameters
  static int getColor(dynamic color, [dynamic x, dynamic y, dynamic z]) {
    bool hasX = x != null;
    bool hasY = y != null;
    bool hasZ = z != null;

    bool noX = x == null;
    bool noY = y == null;
    bool noZ = z == null;

    // check if Colour only use the fist paramter (color)
    // it could be a normal color: Colour(0xFF121212)
    // or a hex based color: Colour('#FF121212') or Colour('FF121212')
    // or Colour('#121212') or Colour('121212')
    bool isSingleParams = noX && noY && noZ;

    if (isSingleParams) {
      if (color is Color) return color.value;
      if (color is int) return color; // Normal color: Colour(0xFF121212)
      return getColorFromHex(color.toString());
    }

    // check if Colour use the first and second parameter (color and x)
    // it can apply to any of 5 formats:
    // Colour(0xFF121212, 0.25)
    // Colour('#FF121212', 0.25)
    // Colour('FF121212', 0.25)
    // Colour('#121212', 0.25)
    // Colour('121212', 0.25)
    bool isDoubleParams = hasX && noY && noZ;
    bool isXOpacity = x is double && x >= 0.0 && x <= 1.0;

    if (isDoubleParams && isXOpacity) {
      Color _color;
      if (color is Color)
        _color = color;
      else if (color is int)
        _color = Color(color);
      else
        _color = Color(getColorFromHex(color.toString()));
      return _color.withOpacity(x).value;
    }

    // check if Colour use only 3 parameters (color, x and y)
    // then it is RGB color => Colour(255, 255, 255)
    bool isTripleParams = hasX && hasY && noZ;
    bool isTripleParamsInteger = color is int && x is int && y is int;

    if (isTripleParams && isTripleParamsInteger) {
      return Color.fromARGB(255, color, x, y).value;
    }

    // check if Colour use all 4 parameters
    // it can apply to any of 2 formats
    // ARGB => Colour(255, 12, 123, 255)
    // RGBO => Colour(12, 123, 255, 0.25)
    bool isAllParams = hasX && hasY && hasZ;

    if (isAllParams) {
      // if all parameters is int, then it is ARGB => Colour(255, 12, 123, 255)
      bool isARGB = color is int && x is int && y is int && z is int;

      if (isARGB) {
        return Color.fromARGB(color, x, y, z).value;
      }

      // if the last paramter is double, then it is RGBO => Colour(12, 123, 255, 0.25)
      bool isRGBO = color is int &&
          x is int &&
          y is int &&
          z is double &&
          z >= 0.0 &&
          z <= 1.0;

      if (isRGBO) {
        return Color.fromRGBO(color, x, y, z).value;
      }
    }

    return color;
  }

  /// parsing hex color for any of the four formats, such as:
  /// getColorFromHex('#FF121212')
  /// getColorFromHex('FF121212')
  /// getColorFromHex('#121212')
  /// getColorFromHex('121212')
  static int getColorFromHex(String color) {
    String hex = color.toUpperCase().replaceAll('#', '');
    if (hex.length == 6) hex = 'FF' + hex;
    return int.parse(hex, radix: 16);
  }
}
