import 'package:flutter/material.dart';
import 'package:ksadanand172_clock_tick/ksadanand172_clock_tick/tic_tic_ticker.dart';

class Ksadanand172ClockTickPage extends StatelessWidget {
  const Ksadanand172ClockTickPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library's entry widget is TicTicTicker.
    // Provide a default title; the widget handles its own Scaffold.
    return const TicTicTicker(title: 'Clock Tick');
  }
}