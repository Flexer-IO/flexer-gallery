import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class HelgewiedingHelg9000Page extends StatelessWidget {
  const HelgewiedingHelg9000Page({super.key});

  @override
  Widget build(BuildContext context) {
    // The library expects a ClockBuilder that receives a ClockModel.
    // We provide a minimal implementation that displays a simple piece of
    // information from the model to keep the UI thin and avoid inventing new
    // visual elements.
    Widget clockBuilder(ClockModel model) {
      return Center(
        child: Text('Location: ${model.location}'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helg9000'),
      ),
      body: ClockCustomizer(clockBuilder),
    );
  }
}