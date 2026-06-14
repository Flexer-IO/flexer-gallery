import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/25.dart';

class CreativecreatorormaybenotFunvas25Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas25Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentyFive()),
      ),
    );
  }
}
