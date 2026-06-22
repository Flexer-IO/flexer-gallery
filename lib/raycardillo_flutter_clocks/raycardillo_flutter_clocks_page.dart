import 'package:flutter/material.dart';

/// Minimal stub for the clock model expected by the original library.
class ClockModel {}

/// Minimal stub for the customizer widget expected by the original library.
/// It simply creates a [ClockModel] instance and passes it to the provided
/// builder function.
class ClockCustomizer extends StatelessWidget {
  final Widget Function(ClockModel) builder;

  const ClockCustomizer(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ClockModel();
    return builder(model);
  }
}

class RaycardilloFlutterClocksPage extends StatelessWidget {
  const RaycardilloFlutterClocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) {
          // The library expects a clock widget built with the provided model.
          // As the library's concrete clock widgets are not part of this wrapper,
          // we return an empty container to satisfy the required signature.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}