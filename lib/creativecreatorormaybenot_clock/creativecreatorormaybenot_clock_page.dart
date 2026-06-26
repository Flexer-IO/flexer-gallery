import 'package:flutter/material.dart';

import 'clock.dart';
import 'clock_palettes.dart';
import 'clock_palette_picker.dart';
import 'real_customizer.dart';

class CreativecreatorormaybenotClockPage extends StatefulWidget {
  const CreativecreatorormaybenotClockPage({super.key});

  @override
  State<CreativecreatorormaybenotClockPage> createState() =>
      _CreativecreatorormaybenotClockPageState();
}

class _CreativecreatorormaybenotClockPageState
    extends State<CreativecreatorormaybenotClockPage> {
  // Palette selection — defaults: first dark + first light both selected
  final Set<int> _selected = {0, 10};
  int _currentIdx = 0;

  ClockPalette get _currentPalette => allClockPalettes[_currentIdx];

  void _onBallArrival() {
    if (_selected.length <= 1) return;
    final sorted = _selected.toList()..sort();
    final pos = sorted.indexOf(_currentIdx);
    final next = sorted[(pos + 1) % sorted.length];
    setState(() => _currentIdx = next);
  }

  void _togglePalette(int idx) {
    setState(() {
      if (_selected.contains(idx)) {
        // keep at least one selected
        if (_selected.length > 1) {
          _selected.remove(idx);
          if (_currentIdx == idx) {
            final sorted = _selected.toList()..sort();
            _currentIdx = sorted.first;
          }
        }
      } else {
        _selected.add(idx);
        _currentIdx = idx;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _currentPalette;
    final bg = palette.colors[ClockColor.background] ?? Colors.black;
    return ColoredBox(
      color: bg,
      child: SafeArea(
        child: RealWeatherCustomizer(
          builder: (context, model) => Stack(
            children: [
              AnimatedClock(
                model: model,
                palette: palette.colors,
                onBallArrival: _onBallArrival,
              ),
              ClockPalettePicker(
                selected: _selected,
                currentIndex: _currentIdx,
                onToggle: _togglePalette,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
