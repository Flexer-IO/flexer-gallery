import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'palette.dart';
import 'palette_picker.dart';
import 'solar_clock.dart';

class PolChenSolarclockPage extends StatefulWidget {
  const PolChenSolarclockPage({super.key});

  @override
  State<PolChenSolarclockPage> createState() => _PolChenSolarclockPageState();
}

class _PolChenSolarclockPageState extends State<PolChenSolarclockPage> {
  static const _prefKey = 'pol_chen_solarclock_palette';

  int _paletteIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPalette();
  }

  Future<void> _loadPalette() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefKey) ?? 0;
    if (!mounted) return;
    setState(() {
      _paletteIndex = saved.clamp(0, SolarPalette.all.length - 1);
    });
  }

  Future<void> _selectPalette(int index) async {
    setState(() => _paletteIndex = index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = SolarPalette.all[_paletteIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SolarClock(palette: palette),
          SolarPalettePicker(
            selectedIndex: _paletteIndex,
            onSelected: _selectPalette,
          ),
        ],
      ),
    );
  }
}
