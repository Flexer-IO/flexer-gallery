import 'package:flutter/material.dart';
import '../packages/bloc/klineBloc.dart';
import '../packages/klinePage.dart';

class ZhaojijinFlutterKlinePage extends StatelessWidget {
  const ZhaojijinFlutterKlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final KlineBloc bloc = KlineBloc();
    return Scaffold(
      body: KlinePageWidget(bloc),
    );
  }
}
