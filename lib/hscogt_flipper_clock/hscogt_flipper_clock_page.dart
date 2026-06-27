import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'digital_clock.dart';
import 'flipper_palette.dart';
import 'flipper_palette_picker.dart';

class HscogtFlipperClockPage extends StatefulWidget {
  const HscogtFlipperClockPage({super.key});

  @override
  State<HscogtFlipperClockPage> createState() => _HscogtFlipperClockPageState();
}

class _HscogtFlipperClockPageState extends State<HscogtFlipperClockPage> {
  static const _prefKey = 'flipper_clock_palette_index';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _restoreSelection();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_prefKey);
    if (value != null && mounted) {
      setState(
        () => _selectedIndex = value.clamp(0, kFlipperPalettes.length - 1),
      );
    }
  }

  void _onPaletteSelected(int index) {
    setState(() => _selectedIndex = index);
    SharedPreferences.getInstance().then((p) => p.setInt(_prefKey, index));
  }

  @override
  Widget build(BuildContext context) {
    final palette = kFlipperPalettes[_selectedIndex];
    return Scaffold(
      backgroundColor: palette.inactive,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black, child: SizedBox.expand()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.paddingOf(context).top,
            child: ColoredBox(color: palette.inactive),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.paddingOf(context).bottom,
            child: ColoredBox(color: palette.inactive),
          ),
          Positioned.fill(
            top: MediaQuery.paddingOf(context).top,
            bottom: MediaQuery.paddingOf(context).bottom,
            child: DigitalClock(palette: palette),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                  focal: Alignment.center,
                  radius: 0.9,
                ),
              ),
            ),
          ),
          FlipperPalettePicker(
            palettes: kFlipperPalettes,
            selectedIndex: _selectedIndex,
            onSelected: _onPaletteSelected,
          ),
        ],
      ),
    );
  }
}
