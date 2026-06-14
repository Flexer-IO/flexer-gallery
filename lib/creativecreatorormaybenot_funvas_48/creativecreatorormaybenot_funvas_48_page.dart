import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/48.dart';

class CreativecreatorormaybenotFunvasFortyEightPage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFortyEightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: FortyEight()),
      ),
    );
  }
}
