import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock.dart';
import 'clock_palettes.dart';
import 'clock_palette_picker.dart';
import 'real_customizer.dart';

const _kSelectedKey = 'creativeclock_selected_palettes';
const _kCurrentKey = 'creativeclock_current_palette';

class CreativecreatorormaybenotClockPage extends StatefulWidget {
  const CreativecreatorormaybenotClockPage({super.key});

  @override
  State<CreativecreatorormaybenotClockPage> createState() =>
      _CreativecreatorormaybenotClockPageState();
}

class _CreativecreatorormaybenotClockPageState
    extends State<CreativecreatorormaybenotClockPage> {
  Set<int> _selected = {_firstDarkIndex()};
  int _currentIdx = _firstDarkIndex();

  static int _firstDarkIndex() {
    final idx = allClockPalettes.indexWhere((p) => p.isDark);
    return idx < 0 ? 0 : idx;
  }

  ClockPalette get _currentPalette => allClockPalettes[_currentIdx];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kSelectedKey);
    final savedCurrent = prefs.getInt(_kCurrentKey);
    if (saved != null && saved.isNotEmpty) {
      final indices =
          saved
              .map(int.tryParse)
              .whereType<int>()
              .where((i) => i >= 0 && i < allClockPalettes.length)
              .toSet();
      if (indices.isNotEmpty && mounted) {
        setState(() {
          _selected = indices;
          _currentIdx =
              (savedCurrent != null && indices.contains(savedCurrent))
                  ? savedCurrent
                  : indices.first;
        });
      }
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kSelectedKey,
      _selected.map((i) => i.toString()).toList(),
    );
    await prefs.setInt(_kCurrentKey, _currentIdx);
  }

  void _onBallArrival() {
    if (_selected.length <= 1) return;
    final sorted = _selected.toList()..sort();
    final pos = sorted.indexOf(_currentIdx);
    final next = sorted[(pos + 1) % sorted.length];
    setState(() => _currentIdx = next);
    _savePrefs();
  }

  void _togglePalette(int idx) {
    setState(() {
      if (_selected.contains(idx)) {
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
    _savePrefs();
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
