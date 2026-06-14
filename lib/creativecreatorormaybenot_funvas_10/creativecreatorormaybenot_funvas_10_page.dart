import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import '../creativecreatorormaybenot_funvas_shared/src/10.dart';

class CreativecreatorormaybenotFunvas10Page extends StatelessWidget {
  const CreativecreatorormaybenotFunvas10Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FunvasContainer(funvas: Ten()),
      ),
    );
  }
}
