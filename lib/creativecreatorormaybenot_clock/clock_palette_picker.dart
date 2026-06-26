import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:showcase_library/showcase_contract.dart';

import 'clock_palettes.dart';
import 'components/style/palette.dart';

class ClockPalettePicker extends StatefulWidget {
  const ClockPalettePicker({
    super.key,
    required this.selected,
    required this.currentIndex,
    required this.onToggle,
  });

  final Set<int> selected;
  final int currentIndex;
  final ValueChanged<int> onToggle;

  @override
  State<ClockPalettePicker> createState() => _ClockPalettePickerState();
}

enum _Filter { all, dark, light }

class _ClockPalettePickerState extends State<ClockPalettePicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  Timer? _timer;
  bool _open = false;
  _Filter _filter = _Filter.all;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _scheduleFade();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fade.dispose();
    super.dispose();
  }

  void _scheduleFade() {
    _timer?.cancel();
    if (_open) return;
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_open) _fade.reverse();
    });
  }

  void _handleTap() {
    _timer?.cancel();
    _fade.forward();
    setState(() => _open = !_open);
    if (!_open) _scheduleFade();
  }

  List<int> get _filtered {
    return List.generate(allClockPalettes.length, (i) => i).where((i) {
      if (_filter == _Filter.dark) return allClockPalettes[i].isDark;
      if (_filter == _Filter.light) return !allClockPalettes[i].isDark;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentPalette = allClockPalettes[widget.currentIndex];
    final accent =
        currentPalette.colors[ClockColor.ballPrimary] ?? Colors.white;
    return Positioned(
      top: 16,
      right: 12,
      child: AnimatedBuilder(
        animation: _fade,
        builder: (context, child) =>
            Opacity(opacity: _open ? 1.0 : _fade.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TriggerButton(
              open: _open,
              accent: accent,
              selectedCount: widget.selected.length,
              onTap: _handleTap,
            ),
            if (_open) ...[
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.scale(
                    scale: 0.92 + 0.08 * t,
                    alignment: Alignment.topRight,
                    child: child,
                  ),
                ),
                child: _DrawerPanel(
                  filteredIndices: _filtered,
                  selected: widget.selected,
                  currentIndex: widget.currentIndex,
                  filter: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                  onToggle: widget.onToggle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({
    required this.open,
    required this.accent,
    required this.selectedCount,
    required this.onTap,
  });

  final bool open;
  final Color accent;
  final int selectedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    open ? Icons.close_rounded : Icons.palette_rounded,
                    key: ValueKey(open),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!open)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: _Badge(count: selectedCount, accent: accent),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count, required this.accent});
  final int count;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent,
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.8), blurRadius: 6),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DrawerPanel extends StatelessWidget {
  const _DrawerPanel({
    required this.filteredIndices,
    required this.selected,
    required this.currentIndex,
    required this.filter,
    required this.onFilterChanged,
    required this.onToggle,
  });

  final List<int> filteredIndices;
  final Set<int> selected;
  final int currentIndex;
  final _Filter filter;
  final ValueChanged<_Filter> onFilterChanged;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerPanZoomStart: (_) =>
          const ShowcasePopVetoNotification().dispatch(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: 240,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.72,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.32),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(
                  selectedCount: selected.length,
                  totalCount: allClockPalettes.length,
                ),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
                _FilterTabs(current: filter, onChanged: onFilterChanged),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: filteredIndices.length,
                    itemExtent: 56.0,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemBuilder: (context, i) {
                      final idx = filteredIndices[i];
                      final palette = allClockPalettes[idx];
                      return _PaletteTile(
                        palette: palette,
                        checked: selected.contains(idx),
                        isCurrent: idx == currentIndex,
                        onTap: () => onToggle(idx),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.selectedCount, required this.totalCount});
  final int selectedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: [
          const Icon(Icons.palette_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            'Palettes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$selectedCount / $totalCount',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.current, required this.onChanged});
  final _Filter current;
  final ValueChanged<_Filter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          _Tab(
            label: 'All',
            icon: Icons.apps_rounded,
            active: current == _Filter.all,
            onTap: () => onChanged(_Filter.all),
          ),
          const SizedBox(width: 6),
          _Tab(
            label: 'Dark',
            icon: Icons.dark_mode_rounded,
            active: current == _Filter.dark,
            onTap: () => onChanged(_Filter.dark),
          ),
          const SizedBox(width: 6),
          _Tab(
            label: 'Light',
            icon: Icons.light_mode_rounded,
            active: current == _Filter.light,
            onTap: () => onChanged(_Filter.light),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active
                  ? Colors.white.withValues(alpha: 0.40)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: Colors.white.withValues(alpha: active ? 1.0 : 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: active ? 1.0 : 0.5),
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const _PaletteTile({
    required this.palette,
    required this.checked,
    required this.isCurrent,
    required this.onTap,
  });

  final ClockPalette palette;
  final bool checked;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = palette.colors[ClockColor.background] ?? Colors.black;
    final ball = palette.colors[ClockColor.ballPrimary] ?? Colors.white;
    final goo = palette.colors[ClockColor.goo] ?? Colors.grey;
    final analog =
        palette.colors[ClockColor.analogTimeBackground] ?? Colors.grey;
    final accent = ball;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isCurrent ? Colors.white.withValues(alpha: 0.12) : null,
            border: Border(
              left: BorderSide(
                color: isCurrent ? accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              // color swatches
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 48,
                  height: 28,
                  child: Row(
                    children: [
                      Expanded(child: ColoredBox(color: bg)),
                      Expanded(child: ColoredBox(color: goo)),
                      Expanded(child: ColoredBox(color: analog)),
                      Expanded(child: ColoredBox(color: ball)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      palette.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      palette.isDark ? '🌙 dark' : '☀️ light',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked ? accent : Colors.transparent,
                  border: Border.all(
                    color: checked
                        ? accent
                        : Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
