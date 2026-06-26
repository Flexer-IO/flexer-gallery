import 'package:flutter/material.dart';

import 'constants.dart';
import 'snake_clock.dart';
import 'palette_picker.dart';

class GildevSnakeclockPage extends StatefulWidget {
  const GildevSnakeclockPage({super.key});

  @override
  State<GildevSnakeclockPage> createState() => _GildevSnakeclockPageState();
}

class _GildevSnakeclockPageState extends State<GildevSnakeclockPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final palette = snakePalettes[_selectedIndex];
    return Stack(
      children: [
        SnakeClock(colors: palette.colors),
        SnakePalettePicker(
          palettes: snakePalettes,
          selectedIndex: _selectedIndex,
          onSelected: (i) => setState(() => _selectedIndex = i),
        ),
      ],
    );
  }
}
