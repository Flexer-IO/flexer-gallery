import 'package:flutter/material.dart';
import 'cloud.dart';

enum WeatherCondition { cloudy }

class Cloudy extends StatefulWidget {
  final WeatherCondition weatherCondition;
  final bool isDarkMode;

  const Cloudy({
    Key? key,
    required this.weatherCondition,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<Cloudy> createState() => _CloudyState();
}

class _CloudyState extends State<Cloudy> {
  @override
  Widget build(BuildContext context) {
    if (widget.weatherCondition == WeatherCondition.cloudy && !widget.isDarkMode) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(children: [
            Cloud(assetNumber: 1, constraints: constraints),
            Cloud(assetNumber: 2, constraints: constraints),
            Cloud(assetNumber: 3, constraints: constraints),
            Cloud(assetNumber: 4, constraints: constraints),
          ]);
        },
      );
    } else {
      return Container();
    }
  }
}