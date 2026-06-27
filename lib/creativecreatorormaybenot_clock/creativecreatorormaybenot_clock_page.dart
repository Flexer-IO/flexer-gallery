import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock.dart';
import 'clock_palette_picker.dart';
import 'deps/flutter_clock_helper/model.dart';
import 'clock_palettes.dart';

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
  // Palette state
  late Set<int> _selected = _defaultSelected();
  int _currentIdx = _firstDarkIndex();

  // Clock model state (replaces Customizer/AutomatedCustomizer)
  late final ClockModel _model;
  Timer? _dataTimer;
  int _dataIdx = 0;

  static int _firstDarkIndex() {
    final idx = allClockPalettes.indexWhere((p) => p.isDark);
    return idx < 0 ? 0 : idx;
  }

  static Set<int> _defaultSelected() {
    final dark = allClockPalettes
        .asMap()
        .entries
        .where((e) => e.value.isDark)
        .take(2)
        .map((e) => e.key)
        .toSet();
    return dark.isEmpty ? {0} : dark;
  }

  ClockPalette get _currentPalette => allClockPalettes[_currentIdx];

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
    _model.addListener(_onModelChange);
    _applyData(0);
    _dataTimer = Timer.periodic(nextDataEvery, (_) {
      _dataIdx = (_dataIdx + 1) % data.length;
      _applyData(_dataIdx);
    });
    _loadPrefs();
  }

  void _onModelChange() => setState(() {});

  void _applyData(int i) {
    final d = i == 0
        ? data[0]
        : data[0].copyWith(data[i]);

    final loc = d.location;
    final cond = d.condition;
    final u = d.unit;
    final temp = d.temperature;
    final hi = d.high;
    final lo = d.low;

    if (loc != null) _model.location = loc;
    if (cond != null) _model.weatherCondition = cond;
    if (u != null) _model.unit = u;
    if (temp != null) _model.temperature = temp;
    if (hi != null) _model.high = hi;
    if (lo != null) _model.low = lo;
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    _model.removeListener(_onModelChange);
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kSelectedKey);
    final savedCurrent = prefs.getInt(_kCurrentKey);
    if (saved != null && saved.isNotEmpty) {
      final indices = saved
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 5 / 3,
                child: AnimatedClock(
                  model: _model,
                  palette: palette.colors,
                  onBallArrival: _onBallArrival,
                ),
              ),
            ),
            ClockPalettePicker(
              selected: _selected,
              currentIndex: _currentIdx,
              onToggle: _togglePalette,
            ),
          ],
        ),
      ),
    );
  }
}
