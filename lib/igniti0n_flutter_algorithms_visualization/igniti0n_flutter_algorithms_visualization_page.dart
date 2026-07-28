import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ui/widgets/world.dart';

class Igniti0nFlutterAlgorithmsVisualizationPage extends StatelessWidget {
  const Igniti0nFlutterAlgorithmsVisualizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: World(),
    );
  }
}
