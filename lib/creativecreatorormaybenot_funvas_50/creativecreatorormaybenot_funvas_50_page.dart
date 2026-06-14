import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/50.dart';

class CreativecreatorormaybenotFunvasFiftyPage extends StatelessWidget {
  const CreativecreatorormaybenotFunvasFiftyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Fifty()),
      ),
    );
  }
}
