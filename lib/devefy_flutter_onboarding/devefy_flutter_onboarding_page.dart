import 'package:flutter/material.dart';
import 'data.dart';
import 'main.dart';
import 'page_indicator.dart';

class DevefyFlutterOnboardingPage extends StatelessWidget {
  const DevefyFlutterOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library's own entry widget is `MyApp` defined in `main.dart`.
    // It already contains all required onboarding UI.
    return MyApp();
  }
}
