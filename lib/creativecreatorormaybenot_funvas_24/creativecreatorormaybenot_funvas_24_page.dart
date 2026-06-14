import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/24.dart';

class CreativecreatorormaybenotFunvas24Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas24Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentyFour()),
      ),
    );
  }
}
