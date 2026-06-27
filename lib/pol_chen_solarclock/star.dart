import 'package:flutter/material.dart';

abstract class Star extends StatelessWidget {
  const Star({super.key, required this.radius, required this.center});

  final double radius;
  final Offset center;
}
