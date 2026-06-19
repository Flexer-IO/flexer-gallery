import 'dart:async';
import 'dart:convert';

import 'deps/flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'palette.dart';
import 'palette_picker.dart';
import 'scene.dart';

class ParticleClock extends StatefulWidget {
  const ParticleClock(this.model);
  final ClockModel model;

  @override
  State<ParticleClock> createState() => _ParticleClockState();
}

class _ParticleClockState extends State<ParticleClock> {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;
  double seek = 0.0;
  double seekIncrement = 1 / 3600;

  static const _prefKey = 'particle_clock_selection';

  Future<List<Palette>>? _palettesFuture;

  /// Palette the clock is locked to, or null to rotate per [_mode].
  int? _selectedPaletteIndex;

  /// Which pool to rotate through when no single palette is locked.
  PaletteMode _mode = PaletteMode.all;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _updateTime();
    _updateModel();
    _restoreSelection();
  }

  Future<void> _restoreSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefKey);
    if (value == null || !mounted) return;
    setState(() {
      if (value.startsWith('i:')) {
        _selectedPaletteIndex = int.tryParse(value.substring(2));
        _mode = PaletteMode.all;
      } else {
        _selectedPaletteIndex = null;
        _mode = PaletteMode.values.firstWhere(
          (m) => m.name == value,
          orElse: () => PaletteMode.all,
        );
      }
    });
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      _selectedPaletteIndex != null ? 'i:$_selectedPaletteIndex' : _mode.name,
    );
  }

  void _onPaletteSelected(int index) {
    setState(() => _selectedPaletteIndex = index);
    _persist();
  }

  void _onModeSelected(PaletteMode mode) {
    setState(() {
      _selectedPaletteIndex = null;
      _mode = mode;
    });
    _persist();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load palettes once instead of on every per-second rebuild.
    _palettesFuture ??= _loadPalettes();
  }

  @override
  void didUpdateWidget(ParticleClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  Future<List<Palette>> _loadPalettes() async {
    String data = await DefaultAssetBundle.of(context).loadString(
      "packages/showcase_library/assets/miickel_flutter_particle_clock/palettes.json",
    );
    var palettes = json.decode(data) as List;
    return palettes.map((p) => Palette.fromJson(p)).toList();
  }

  void _updateModel() {
    // Cause the clock to rebuild when the model changes.
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Palette>>(
      future: _palettesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ColoredBox(
            color: Colors.black,
            child: Center(child: Text("Could not load palettes.")),
          );
        }

        final palettes = snapshot.data!;
        // Guard against a restored index that no longer fits the list.
        final selected =
            (_selectedPaletteIndex != null &&
                _selectedPaletteIndex! < palettes.length)
            ? _selectedPaletteIndex
            : null;

        return Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Scene(
                  size: constraints.biggest,
                  palettes: palettes,
                  time: _dateTime,
                  brightness: Theme.of(context).brightness,
                  selectedIndex: selected,
                  mode: _mode,
                );
              },
            ),
            PalettePicker(
              palettes: palettes,
              selectedIndex: selected,
              mode: _mode,
              onSelected: _onPaletteSelected,
              onModeSelected: _onModeSelected,
            ),
          ],
        );
      },
    );
  }
}
