import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analogue_clock.dart';
import 'clock_palette.dart';
import 'clock_palette_picker.dart';

class IsatippensFlutterClockPage extends StatefulWidget {
  const IsatippensFlutterClockPage({super.key});

  @override
  State<IsatippensFlutterClockPage> createState() =>
      _IsatippensFlutterClockPageState();
}

class _IsatippensFlutterClockPageState
    extends State<IsatippensFlutterClockPage> {
  static const _prefKey = 'isatippens_clock_palette';

  Future<List<ClockPalette>>? _palettesFuture;
  int? _selectedIndex;
  ClockPaletteMode _mode = ClockPaletteMode.dark;

  @override
  void initState() {
    super.initState();
    _restoreSelection();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _palettesFuture ??= _loadPalettes();
  }

  Future<List<ClockPalette>> _loadPalettes() async {
    final data = await DefaultAssetBundle.of(context).loadString(
      'packages/showcase_library/assets/miickel_flutter_particle_clock/palettes.json',
    );
    final raw = json.decode(data) as List;
    return raw.map((p) => ClockPalette.fromJson(p as List)).toList();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefKey);
    if (value == null || !mounted) return;
    setState(() {
      if (value.startsWith('i:')) {
        _selectedIndex = int.tryParse(value.substring(2));
        _mode = ClockPaletteMode.dark;
      } else {
        _selectedIndex = null;
        _mode = ClockPaletteMode.values.firstWhere(
          (m) => m.name == value,
          orElse: () => ClockPaletteMode.dark,
        );
      }
    });
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      _selectedIndex != null ? 'i:$_selectedIndex' : _mode.name,
    );
  }

  void _onPaletteSelected(int index) {
    setState(() => _selectedIndex = index);
    _persist();
  }

  void _onModeSelected(ClockPaletteMode mode) {
    setState(() {
      _selectedIndex = null;
      _mode = mode;
    });
    _persist();
  }

  ClockPalette _currentPalette(List<ClockPalette> palettes) {
    if (_selectedIndex != null && _selectedIndex! < palettes.length) {
      return palettes[_selectedIndex!];
    }
    final filtered = switch (_mode) {
      ClockPaletteMode.dark => palettes.where((p) => p.isDark).toList(),
      ClockPaletteMode.light => palettes.where((p) => !p.isDark).toList(),
      ClockPaletteMode.all => palettes,
    };
    return filtered.isNotEmpty ? filtered.first : palettes.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClockPalette>>(
      future: _palettesFuture,
      builder: (context, snapshot) {
        final palettes = snapshot.data;
        final palette = palettes != null ? _currentPalette(palettes) : null;
        final bg = palette?.bg ?? Colors.black;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 5 / 3,
                    child: AnalogueClock(palette: palette),
                  ),
                ),
                if (palettes != null)
                  ClockPalettePicker(
                    palettes: palettes,
                    selectedIndex: _selectedIndex,
                    mode: _mode,
                    onSelected: _onPaletteSelected,
                    onModeSelected: _onModeSelected,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
