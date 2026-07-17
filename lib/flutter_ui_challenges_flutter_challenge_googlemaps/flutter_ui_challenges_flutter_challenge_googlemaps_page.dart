import 'package:flutter/material.dart';
import 'package:flutter_ui_challenges_flutter_challenge_googlemaps/google_map_page.dart';

class FlutterUiChallengesFlutterChallengeGooglemapsPage extends StatelessWidget {
  const FlutterUiChallengesFlutterChallengeGooglemapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMapPage(),
    );
  }
}