import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'flipper_palette.dart';
import 'tile.dart';
import 'tile_params.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key, required this.palette});

  final FlipperPalette palette;

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;
  late List<TileParams> _tiles;
  final bool _is24Hour = true;

  @override
  void initState() {
    super.initState();
    _tiles = List.generate(
      119,
      (_) => TileParams(
        inactiveColor: widget.palette.inactive,
        primaryColor: widget.palette.inactive,
        secondaryColor: widget.palette.inactive,
      ),
    );
    _updateTime();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.palette != oldWidget.palette) _applyPalette();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _applyPalette() {
    for (final tile in _tiles) {
      tile.inactiveColor = widget.palette.inactive;
    }
    final time = DateFormat(_is24Hour ? 'HHmm' : 'hhmm').format(_dateTime);
    _refreshNumbers(time);
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      final time = DateFormat(_is24Hour ? 'HHmm' : 'hhmm').format(_dateTime);
      _refreshNumbers(time);
    });
  }

  void _refreshNumbers(String time) {
    for (var i = 0; i < 4; i++) {
      final areaIndexes = _getAreaIndexes(i + 1);
      final activeIndexes = _getIndexesForNumber(
        int.parse(time[i]),
        _getAreaIndexes(i + 1),
      );
      for (final idx in areaIndexes) {
        _tiles[idx].isActive = activeIndexes.contains(idx);
      }
      _setColors(areaIndexes);
    }
  }

  void _setColors(List<int> areaIndexes) {
    for (var i = 0; i < 15; i++) {
      final idx = areaIndexes[i];
      final groupIndex = i ~/ 3;
      if (_tiles[idx].isActive) {
        final c = widget.palette.active[groupIndex];
        _tiles[idx].primaryColor = c;
        _tiles[idx].secondaryColor = Color.lerp(c, Colors.black, 0.28)!;
      } else {
        _tiles[idx].primaryColor = widget.palette.inactive;
        _tiles[idx].secondaryColor = widget.palette.inactive;
      }
    }
  }

  List<int> _getAreaIndexes(int digitInHour) {
    final base = [18, 19, 20, 35, 36, 37, 52, 53, 54, 69, 70, 71, 86, 87, 88];
    switch (digitInHour) {
      case 1:
        return base;
      case 2:
        return base.map((i) => i + 4).toList();
      case 3:
        return base.map((i) => i + 8).toList();
      case 4:
        return base.map((i) => i + 12).toList();
      default:
        return [];
    }
  }

  List<int> _getIndexesForNumber(int digit, List<int> indexes) {
    switch (digit) {
      case 0:
        indexes.removeAt(10);
        indexes.removeAt(7);
        indexes.removeAt(4);
      case 1:
        indexes.removeAt(13);
        indexes.removeAt(12);
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(7);
        indexes.removeAt(6);
        indexes.removeAt(4);
        indexes.removeAt(3);
        indexes.removeAt(1);
        indexes.removeAt(0);
      case 2:
        indexes.removeAt(11);
        indexes.removeAt(10);
        indexes.removeAt(4);
        indexes.removeAt(3);
      case 3:
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(4);
        indexes.removeAt(3);
      case 4:
        indexes.removeAt(13);
        indexes.removeAt(12);
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(4);
        indexes.removeAt(1);
      case 5:
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(5);
        indexes.removeAt(4);
      case 6:
        indexes.removeAt(10);
        indexes.removeAt(5);
        indexes.removeAt(4);
      case 7:
        indexes.removeAt(13);
        indexes.removeAt(12);
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(7);
        indexes.removeAt(6);
        indexes.removeAt(4);
        indexes.removeAt(3);
      case 8:
        indexes.removeAt(10);
        indexes.removeAt(4);
      case 9:
        indexes.removeAt(13);
        indexes.removeAt(12);
        indexes.removeAt(10);
        indexes.removeAt(9);
        indexes.removeAt(4);
    }
    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        7,
        (row) => Expanded(
          child: Row(
            children: List.generate(
              17,
              (col) =>
                  Expanded(child: Tile(tileParams: _tiles[row * 17 + col])),
            ),
          ),
        ),
      ),
    );
  }
}
