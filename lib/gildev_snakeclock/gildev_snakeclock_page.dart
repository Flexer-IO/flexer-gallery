import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'snake_clock.dart';
import 'palette_picker.dart';

const _kSelectedKey = 'snakeclock_selected_palette';

class GildevSnakeclockPage extends StatefulWidget {
  const GildevSnakeclockPage({super.key});

  @override
  State<GildevSnakeclockPage> createState() => _GildevSnakeclockPageState();
}

class _GildevSnakeclockPageState extends State<GildevSnakeclockPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_kSelectedKey);
    if (saved != null && saved >= 0 && saved < snakePalettes.length && mounted) {
      setState(() => _selectedIndex = saved);
    }
  }

  Future<void> _savePrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSelectedKey, index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = snakePalettes[_selectedIndex];
    return SafeArea(
      child: Stack(
        children: [
          SnakeClock(colors: palette.colors),
          SnakePalettePicker(
            palettes: snakePalettes,
            selectedIndex: _selectedIndex,
            onSelected: (i) {
              setState(() => _selectedIndex = i);
              _savePrefs(i);
            },
          ),
        ],
      ),
    );
  }
}
