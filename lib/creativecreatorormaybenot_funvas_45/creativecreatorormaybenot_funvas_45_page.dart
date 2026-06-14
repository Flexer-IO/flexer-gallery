import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/45.dart';

class CreativecreatorormaybenotFunvasFortyFivePage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFortyFivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: FortyFive()),
      ),
    );
  }
}
