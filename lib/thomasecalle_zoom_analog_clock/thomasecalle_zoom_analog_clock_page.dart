import 'package:flutter/material.dart';

/// Minimal placeholder for the clock model expected by the library.
class ClockModel {
  const ClockModel();
}

/// Minimal placeholder for the clock customizer widget expected by the library.
/// It receives a builder that takes a [ClockModel] and returns a widget.
class ClockCustomizer extends StatelessWidget {
  final Widget Function(ClockModel) builder;

  const ClockCustomizer(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide a dummy model to the builder.
    const ClockModel model = ClockModel();
    return builder(model);
  }
}

class ThomasecalleZoomAnalogClockPage extends StatelessWidget {
  const ThomasecalleZoomAnalogClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library expects a ClockBuilder that receives a ClockModel.
    // We provide a minimal widget that satisfies the builder contract.
    Widget clockBuilder(ClockModel model) {
      // The actual analog clock implementation is part of the library.
      // Here we simply display a placeholder text; the ClockCustomizer
      // will still manage the model and theme handling.
      return Center(
        child: Text(
          'Zoom Analog Clock',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Analog Clock'),
      ),
      body: ClockCustomizer(clockBuilder),
    );
  }
}