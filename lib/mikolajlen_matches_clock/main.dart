import 'package:flutter/material.dart';
import 'match.dart' as match;
import 'match_clock_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainWidget(),
      );
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final creator = match.MatchesCreator()
      ..calculateMatchesSize(MediaQuery.of(context).size);
    return MatchClockWidget(
      key: UniqueKey(),
      creator: creator as MatchesCreator,
    );
  }
}