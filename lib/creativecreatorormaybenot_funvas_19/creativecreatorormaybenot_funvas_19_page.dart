import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/19.dart';

class CreativecreatorormaybenotFunvas19Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas19Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Nineteen()),
      ),
    );
  }
}
