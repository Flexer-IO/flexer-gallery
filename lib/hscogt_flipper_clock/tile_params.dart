import 'package:flutter/material.dart';

class TileParams {
  bool isActive;
  Color primaryColor;
  Color secondaryColor;
  Color inactiveColor;
  String text;
  IconData? icon;

  TileParams({
    this.isActive = false,
    this.primaryColor = const Color(0xFF232F4A),
    this.secondaryColor = const Color(0xFF232F4A),
    this.inactiveColor = const Color(0xFF232F4A),
    this.text = '',
    this.icon,
  });
}
