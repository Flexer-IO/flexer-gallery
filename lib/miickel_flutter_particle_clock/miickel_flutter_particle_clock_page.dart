import 'package:flutter/material.dart';
import 'particle_clock.dart';
import 'deps/flutter_clock_helper/model.dart' as clock_helper;

class MiickelFlutterParticleClockPage extends StatelessWidget {
  const MiickelFlutterParticleClockPage({super.key});

  @override
  Widget build(BuildContext context) => ParticleClock(clock_helper.ClockModel());
}