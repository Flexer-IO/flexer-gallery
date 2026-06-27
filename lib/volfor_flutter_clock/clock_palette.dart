import 'package:flutter/material.dart';

class ClockPalette {
  final String name;
  final Color background;
  final Color arrows;
  final Color circlesBackground;

  const ClockPalette({
    required this.name,
    required this.background,
    required this.arrows,
    required this.circlesBackground,
  });
}

const kDefaultPaletteIndex = 0;

const kClockPalettes = <ClockPalette>[
  // ── Dark ──────────────────────────────────────────────────────────
  ClockPalette(name: 'Midnight', background: Color(0xFF000000), arrows: Color(0xFFFFFFFF), circlesBackground: Color(0x1FFFFFFF)),
  ClockPalette(name: 'Navy',     background: Color(0xFF0A0E1A), arrows: Color(0xFF4DD9FF), circlesBackground: Color(0x1F4DD9FF)),
  ClockPalette(name: 'Forest',   background: Color(0xFF051A0A), arrows: Color(0xFF39FF82), circlesBackground: Color(0x1F39FF82)),
  ClockPalette(name: 'Void',     background: Color(0xFF0D001A), arrows: Color(0xFFD966FF), circlesBackground: Color(0x1FD966FF)),
  ClockPalette(name: 'Ember',    background: Color(0xFF1A0500), arrows: Color(0xFFFF6B35), circlesBackground: Color(0x1FFF6B35)),
  ClockPalette(name: 'Amber',    background: Color(0xFF1A1000), arrows: Color(0xFFFFBF00), circlesBackground: Color(0x1FFFBF00)),
  ClockPalette(name: 'Teal',     background: Color(0xFF001A1A), arrows: Color(0xFF00E5CC), circlesBackground: Color(0x1F00E5CC)),
  ClockPalette(name: 'Indigo',   background: Color(0xFF0A0A2E), arrows: Color(0xFFB3B3FF), circlesBackground: Color(0x1FB3B3FF)),
  ClockPalette(name: 'Ocean',    background: Color(0xFF001829), arrows: Color(0xFF00B4D8), circlesBackground: Color(0x1F00B4D8)),
  ClockPalette(name: 'Rose',     background: Color(0xFF1A000D), arrows: Color(0xFFFF6B9D), circlesBackground: Color(0x1FFF6B9D)),
  ClockPalette(name: 'Slate',    background: Color(0xFF0D1117), arrows: Color(0xFF79C0FF), circlesBackground: Color(0x1F79C0FF)),
  ClockPalette(name: 'Gold',     background: Color(0xFF100D00), arrows: Color(0xFFFFD700), circlesBackground: Color(0x1FFFD700)),
  // ── Light ─────────────────────────────────────────────────────────
  ClockPalette(name: 'Paper',    background: Color(0xFFFFFFFF), arrows: Color(0xFF000000), circlesBackground: Color(0x1F000000)),
  ClockPalette(name: 'Warm',     background: Color(0xFFF5F0E8), arrows: Color(0xFF3D2B1F), circlesBackground: Color(0x1F3D2B1F)),
  ClockPalette(name: 'Sky',      background: Color(0xFFE8F4FD), arrows: Color(0xFF1B4F72), circlesBackground: Color(0x1F1B4F72)),
];
