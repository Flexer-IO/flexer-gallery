import 'package:flutter/material.dart';
import 'package:shorebirdtech_time_shift/clocks/generative_clock.dart';
import 'package:shorebirdtech_time_shift/clocks/particle_clock.dart';

/// All available clock faces.
enum ClockFace {
  generative,
  particle,
}

extension ClockFaceWidget on ClockFace {
  /// Builds the clock face widget associated with this [ClockFace].
  Widget get widget {
    switch (this) {
      case ClockFace.generative:
        return const GenerativeClock();
      case ClockFace.particle:
        return const ParticleClock();
    }
  }
}