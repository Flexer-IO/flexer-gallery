import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/9.dart';

class CreativecreatorormaybenotFunvas9Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas9Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Nine()),
      ),
    );
  }
}
