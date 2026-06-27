import 'package:flutter/material.dart';

class FlipperPalette {
  final String name;
  final Color inactive;
  final List<Color> active;

  const FlipperPalette({
    required this.name,
    required this.inactive,
    required this.active,
  });
}

const kFlipperPalettes = [
  FlipperPalette(
    name: 'Warm Rose',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFEF8D8),
      Color(0xFFF9DEB7),
      Color(0xFFE79D9B),
      Color(0xFFD56085),
      Color(0xFF974180),
    ],
  ),
  FlipperPalette(
    name: 'Deep Ocean',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFF80DEEA),
      Color(0xFF26C6DA),
      Color(0xFF0097A7),
      Color(0xFF00607A),
      Color(0xFF003040),
    ],
  ),
  FlipperPalette(
    name: 'Neon Cyan',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFE0FFFF),
      Color(0xFF80FFFF),
      Color(0xFF00E5FF),
      Color(0xFF0097A7),
      Color(0xFF004D60),
    ],
  ),
  FlipperPalette(
    name: 'Ember',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFFE082),
      Color(0xFFFFB74D),
      Color(0xFFF57C00),
      Color(0xFFBF360C),
      Color(0xFF7F0000),
    ],
  ),
  FlipperPalette(
    name: 'Purple Haze',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFEA80FC),
      Color(0xFFCE93D8),
      Color(0xFF9C27B0),
      Color(0xFF6A1B9A),
      Color(0xFF380145),
    ],
  ),
  FlipperPalette(
    name: 'Matrix',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFCCFF90),
      Color(0xFF69F0AE),
      Color(0xFF00E676),
      Color(0xFF00C853),
      Color(0xFF1B5E20),
    ],
  ),
  FlipperPalette(
    name: 'Blood Moon',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFF8A80),
      Color(0xFFFF5252),
      Color(0xFFD50000),
      Color(0xFF8B0000),
      Color(0xFF3E0000),
    ],
  ),
  FlipperPalette(
    name: 'Gold Rush',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFFF176),
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
      Color(0xFFFF6F00),
      Color(0xFF4E2700),
    ],
  ),
  FlipperPalette(
    name: 'Arctic',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFE3F2FD),
      Color(0xFF90CAF9),
      Color(0xFF2196F3),
      Color(0xFF0D47A1),
      Color(0xFF001440),
    ],
  ),
  FlipperPalette(
    name: 'Nebula',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFF80AB),
      Color(0xFFFF4081),
      Color(0xFFF50057),
      Color(0xFFAD1457),
      Color(0xFF570C30),
    ],
  ),
  FlipperPalette(
    name: 'Toxic Lime',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFEEFF41),
      Color(0xFFC6FF00),
      Color(0xFF76FF03),
      Color(0xFF00BFA5),
      Color(0xFF004D40),
    ],
  ),
  FlipperPalette(
    name: 'Inferno',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFFFF00),
      Color(0xFFFF9800),
      Color(0xFFF44336),
      Color(0xFFB71C1C),
      Color(0xFF4E0000),
    ],
  ),
  FlipperPalette(
    name: 'Magenta Storm',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFF80FF),
      Color(0xFFFF40F0),
      Color(0xFFE040FB),
      Color(0xFF7B1FA2),
      Color(0xFF380038),
    ],
  ),
  FlipperPalette(
    name: 'Cobalt Night',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFF82B1FF),
      Color(0xFF448AFF),
      Color(0xFF2962FF),
      Color(0xFF1A237E),
      Color(0xFF080D38),
    ],
  ),
  FlipperPalette(
    name: 'Jade',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFB9F6CA),
      Color(0xFF69F0AE),
      Color(0xFF00E676),
      Color(0xFF00897B),
      Color(0xFF004D40),
    ],
  ),
  FlipperPalette(
    name: 'Deep Amethyst',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFB39DDB),
      Color(0xFF9575CD),
      Color(0xFF7E57C2),
      Color(0xFF512DA8),
      Color(0xFF1A0050),
    ],
  ),
  FlipperPalette(
    name: 'Solar Flare',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFFF59D),
      Color(0xFFFFCC02),
      Color(0xFFFF6D00),
      Color(0xFFDD2C00),
      Color(0xFF4E0000),
    ],
  ),
  FlipperPalette(
    name: 'Electric Indigo',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFB388FF),
      Color(0xFF7C4DFF),
      Color(0xFF651FFF),
      Color(0xFF311B92),
      Color(0xFF100060),
    ],
  ),
  FlipperPalette(
    name: 'Rose Quartz',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFFB3C1),
      Color(0xFFFF6B81),
      Color(0xFFFF1744),
      Color(0xFFC2185B),
      Color(0xFF5C0020),
    ],
  ),
  FlipperPalette(
    name: 'Lava',
    inactive: Color(0xFF1B2433),
    active: [
      Color(0xFFFF6E40),
      Color(0xFFFF3D00),
      Color(0xFFDD2C00),
      Color(0xFF8D1A00),
      Color(0xFF3E0000),
    ],
  ),
];
