import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/44.dart';

class CreativecreatorormaybenotFunvasFortyFourPage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFortyFourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: FortyFour()),
      ),
    );
  }
}
