import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/26.dart';

class CreativecreatorormaybenotFunvas26Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas26Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: TwentySix()),
      ),
    );
  }
}
