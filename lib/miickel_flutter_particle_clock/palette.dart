import 'dart:ui';

/// How the clock rotates palettes when not locked to a single one.
enum PaletteMode { all, dark, light }

/// Holds a list of colors.
class Palette {
  /// The palette's color members. All unique.
  List<Color>? components;

  Palette({this.components});

  /// Creates a new palette from JSON.
  factory Palette.fromJson(List<dynamic> json) {
    var components = json.map((c) => Color(int.tryParse(c)!)).toList();
    return Palette(components: components);
  }
}
