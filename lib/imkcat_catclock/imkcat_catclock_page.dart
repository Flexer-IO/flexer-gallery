import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import '../cat_clock.dart';

class ImkcatCatclockPage extends StatelessWidget {
  const ImkcatCatclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) => CatClock(model),
      ),
    );
  }
}
