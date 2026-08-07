import 'package:flutter/material.dart';
import 'package:larvalabs_flutterweb_github_dataviz/main.dart' as github_dataviz;

class LarvalabsFlutterwebGithubDatavizPage extends StatelessWidget {
  const LarvalabsFlutterwebGithubDatavizPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library's main entry widget is defined in `main.dart`.
    // It is instantiated here without any additional configuration.
    return github_dataviz.GithubDataVizApp();
  }
}