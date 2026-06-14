import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/42.dart';

class CreativecreatorormaybenotFunvasFortyTwoPage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFortyTwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: FortyTwo()),
      ),
    );
  }
}
