import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import '../custom_icons_icons.dart';
import '../digital_clock.dart';
import '../tile.dart';
import '../tile_params.dart';

class HscogtFlipperClockPage extends StatefulWidget {
  const HscogtFlipperClockPage({super.key});

  @override
  State<HscogtFlipperClockPage> createState() => _HscogtFlipperClockPageState();
}

class _HscogtFlipperClockPageState extends State<HscogtFlipperClockPage> {
  late final ClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DigitalClock(_model),
    );
  }
}
