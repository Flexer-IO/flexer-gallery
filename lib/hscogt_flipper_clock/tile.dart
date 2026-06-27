import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'tile_params.dart';

class Tile extends StatefulWidget {
  const Tile({super.key, required this.tileParams});

  final TileParams tileParams;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with SingleTickerProviderStateMixin {
  double _ratio = 0.0;
  late AnimationController _controller;
  late Color _primaryColor;
  late Color _secondaryColor;
  double _glow = 0;

  bool get isActive => widget.tileParams.isActive;
  Color get primaryColor => widget.tileParams.primaryColor;
  Color get secondaryColor => widget.tileParams.secondaryColor;
  IconData? get icon => widget.tileParams.icon;

  @override
  void initState() {
    super.initState();
    if (isActive) {
      _primaryColor = primaryColor;
      _secondaryColor = secondaryColor;
    } else {
      _primaryColor = widget.tileParams.inactiveColor;
      _secondaryColor = widget.tileParams.inactiveColor;
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.addListener(_tick);
    isActive ? _controller.reverse() : _controller.forward();
  }

  @override
  void didUpdateWidget(Tile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (isActive) {
        _primaryColor = primaryColor;
        _secondaryColor = secondaryColor;
      } else {
        _primaryColor = widget.tileParams.inactiveColor;
        _secondaryColor = widget.tileParams.inactiveColor;
      }
    });
    isActive ? _controller.reverse() : _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = max(0.0, min(1.0, _ratio));
    final mtx = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..setEntry(1, 2, 0.2)
      ..rotateX(pi * (ratio - 1.0));

    return Transform(
      alignment: Alignment.center,
      transform: mtx,
      child: Padding(
        padding: const EdgeInsets.all(0.7),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [_primaryColor, _secondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _secondaryColor,
                    blurRadius: isActive ? _glow : 0,
                    spreadRadius: isActive ? _glow : 0,
                  ),
                ],
              ),
            ),
            Center(
              child: AutoSizeText(
                widget.tileParams.text,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            if (icon != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _tick() {
    setState(() {
      _ratio = Curves.easeInQuad.transform(_controller.value);
      if (isActive) {
        if (_ratio < 0.5) {
          _primaryColor = primaryColor;
          _secondaryColor = secondaryColor;
          _glow = _ratio * 30;
        }
      } else {
        if (_ratio > 0.5) {
          _primaryColor = widget.tileParams.inactiveColor;
          _secondaryColor = widget.tileParams.inactiveColor;
        }
      }
    });
  }
}
