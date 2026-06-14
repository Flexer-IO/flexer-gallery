import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/41.dart';

class CreativecreatorormaybenotFunvasFortyOnePage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFortyOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: FortyOne()),
      ),
    );
  }
}
