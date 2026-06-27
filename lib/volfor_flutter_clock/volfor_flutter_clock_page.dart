import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock_palette.dart';
import 'clock_palette_picker.dart';
import 'deps/flutter_clock_helper/model.dart';
import 'digital_clock.dart';

class VolforFlutterClockPage extends StatefulWidget {
  const VolforFlutterClockPage({super.key});

  @override
  State<VolforFlutterClockPage> createState() => _VolforFlutterClockPageState();
}

class _VolforFlutterClockPageState extends State<VolforFlutterClockPage> {
  final _model = ClockModel();
  int _paletteIndex = kDefaultPaletteIndex;

  static const _prefKey = 'volfor_clock_palette_index';

  @override
  void initState() {
    super.initState();
    _restoreSelection();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefKey);
    if (saved != null &&
        saved >= 0 &&
        saved < kClockPalettes.length &&
        mounted) {
      setState(() => _paletteIndex = saved);
    }
  }

  Future<void> _onPaletteSelected(int index) async {
    setState(() => _paletteIndex = index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = kClockPalettes[_paletteIndex];
    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: DigitalClock(_model, palette: palette),
          ),
          ClockPalettePicker(
            selectedIndex: _paletteIndex,
            onSelected: _onPaletteSelected,
          ),
        ],
      ),
    );
  }
}
