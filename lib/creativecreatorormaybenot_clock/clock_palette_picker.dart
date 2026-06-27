import 'package:flutter/material.dart';

import 'clock_palettes.dart';
import 'components/style/palette.dart';

class ClockPalettePicker extends StatelessWidget {
  final Set<int> selected;
  final int currentIndex;
  final void Function(int) onToggle;

  const ClockPalettePicker({
    super.key,
    required this.selected,
    required this.currentIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                for (var i = 0; i < allClockPalettes.length; i++) ...[
                  _Swatch(
                    palette: allClockPalettes[i],
                    isSelected: selected.contains(i),
                    isCurrent: i == currentIndex,
                    onTap: () => onToggle(i),
                  ),
                  const SizedBox(width: 6),
                ],
                const SizedBox(width: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final ClockPalette palette;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const _Swatch({
    required this.palette,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = palette.colors[ClockColor.background] ?? Colors.grey;

    Widget circle = Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.25),
          width: isSelected ? 2.5 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );

    return Tooltip(
      message: palette.name,
      child: GestureDetector(
        onTap: onTap,
        child: circle,
      ),
    );
  }
}
