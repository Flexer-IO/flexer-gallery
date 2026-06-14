import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/12.dart';

class CreativecreatorormaybenotFunvas12Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas12Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Twelve()),
      ),
    );
  }
}
