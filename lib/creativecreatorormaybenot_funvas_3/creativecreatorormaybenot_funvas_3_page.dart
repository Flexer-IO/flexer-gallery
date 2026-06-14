import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/3.dart';

class CreativecreatorormaybenotFunvas3Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Three()),
      ),
    );
  }
}
