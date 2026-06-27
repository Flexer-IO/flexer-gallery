import 'package:flutter/material.dart';

class SolarPalette {
  const SolarPalette({
    required this.name,
    required this.bgStart,
    required this.bgEnd,
    required this.sunColor,
    required this.earthColor,
    required this.moonColor,
    required this.markerColor,
  });

  final String name;
  final Color bgStart;
  final Color bgEnd;
  final Color sunColor;
  final Color earthColor;
  final Color moonColor;
  final Color markerColor;

  static const all = <SolarPalette>[
    SolarPalette(
      name: 'Deep Space',
      bgStart: Color(0xFF050A18),
      bgEnd: Color(0xFF0F1535),
      sunColor: Color(0xFFFFC107),
      earthColor: Color(0xFF4CAF50),
      moonColor: Color(0xFFBDBDBD),
      markerColor: Color(0x22FFFFFF),
    ),
    SolarPalette(
      name: 'Nebula',
      bgStart: Color(0xFF0D0019),
      bgEnd: Color(0xFF1A0038),
      sunColor: Color(0xFFFF6B35),
      earthColor: Color(0xFF9C27B0),
      moonColor: Color(0xFFE1BEE7),
      markerColor: Color(0x22E1BEE7),
    ),
    SolarPalette(
      name: 'Aurora',
      bgStart: Color(0xFF001A12),
      bgEnd: Color(0xFF00291E),
      sunColor: Color(0xFF00E5FF),
      earthColor: Color(0xFF00BFA5),
      moonColor: Color(0xFFB2EBF2),
      markerColor: Color(0x2200E5FF),
    ),
    SolarPalette(
      name: 'Cosmic Fire',
      bgStart: Color(0xFF1A0300),
      bgEnd: Color(0xFF2D0800),
      sunColor: Color(0xFFFF6D00),
      earthColor: Color(0xFFFF1744),
      moonColor: Color(0xFFFFD740),
      markerColor: Color(0x22FFD740),
    ),
    SolarPalette(
      name: 'Midnight Blue',
      bgStart: Color(0xFF001233),
      bgEnd: Color(0xFF001F54),
      sunColor: Color(0xFF4FC3F7),
      earthColor: Color(0xFF0288D1),
      moonColor: Color(0xFFB3E5FC),
      markerColor: Color(0x224FC3F7),
    ),
    SolarPalette(
      name: 'Monochrome',
      bgStart: Color(0xFF050505),
      bgEnd: Color(0xFF111111),
      sunColor: Color(0xFFFFFFFF),
      earthColor: Color(0xFF888888),
      moonColor: Color(0xFFCCCCCC),
      markerColor: Color(0x33FFFFFF),
    ),
  ];
}
