import 'services/clockanimationservice.dart';
import 'widgets/clockthemeanimation.dart';
import 'package:flutter/material.dart';
import 'deps/provider/provider.dart';

class ClockThemeAnimationWrapper extends StatefulWidget {
  @override
  State<ClockThemeAnimationWrapper> createState() => _ClockThemeAnimationWrapperState();
}

class _ClockThemeAnimationWrapperState extends State<ClockThemeAnimationWrapper> {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<ClockAnimationService>(
      builder: (context, animService, child) {
        return ClockThemeAnimation();
      }
    );
  }
}