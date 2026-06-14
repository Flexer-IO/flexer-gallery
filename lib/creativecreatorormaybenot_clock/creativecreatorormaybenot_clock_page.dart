import 'package:flutter/material.dart';

import 'clock.dart';
import 'customizer/customizer.dart';
import 'composition/animated.dart';
import 'components/style/palette.dart';

class CreativecreatorormaybenotClockPage extends StatelessWidget {
  const CreativecreatorormaybenotClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Customizer(
      mode: CustomizationFlow.automatic,
      builder: (context, model) => Palette(
        builder: (context, palette) =>
            AnimatedClock(model: model, palette: palette),
      ),
    );
  }
}
