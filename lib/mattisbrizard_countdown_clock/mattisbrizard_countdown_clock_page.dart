import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'countdown_clock.dart';
import 'palette_picker.dart';

class MattisbrizardCountdownClockPage extends StatefulWidget {
  const MattisbrizardCountdownClockPage({super.key});

  @override
  State<MattisbrizardCountdownClockPage> createState() =>
      _MattisbrizardCountdownClockPageState();
}

class _MattisbrizardCountdownClockPageState
    extends State<MattisbrizardCountdownClockPage> {
  static const _prefKey = 'countdown_clock_palette';

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _restoreSelection();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_prefKey);
    if (value == null || !mounted) return;
    if (value >= 0 && value < kCountdownPalettes.length) {
      setState(() => _selectedIndex = value);
    }
  }

  Future<void> _persist(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, index);
  }

  void _onPaletteSelected(int index) {
    setState(() => _selectedIndex = index);
    _persist(index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = kCountdownPalettes[_selectedIndex];
    return Scaffold(
      body: Stack(
        children: [
          CountdownClock(
            bgColor: palette.bg,
            remainingColor: palette.remaining,
            elapsedColor: palette.elapsed,
            highlightColor: palette.highlight,
          ),
          CountdownPalettePicker(
            selectedIndex: _selectedIndex,
            onSelected: _onPaletteSelected,
          ),
        ],
      ),
    );
  }
}
