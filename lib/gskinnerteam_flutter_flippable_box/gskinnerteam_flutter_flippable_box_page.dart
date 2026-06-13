// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'flippable_box.dart';

class GskinnerteamFlutterFlippableBoxPage extends StatefulWidget {
  const GskinnerteamFlutterFlippableBoxPage({super.key});

  @override
  State<GskinnerteamFlutterFlippableBoxPage> createState() =>
      _GskinnerteamFlutterFlippableBoxPageState();
}

class _GskinnerteamFlutterFlippableBoxPageState
    extends State<GskinnerteamFlutterFlippableBoxPage> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlippableBox(
              isFlipped: _isFlipped,
              front: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text('Front', style: TextStyle(color: Colors.white)),
                ),
              ),
              back: Container(
                width: 200,
                height: 200,
                color: Colors.red,
                child: const Center(
                  child: Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFlipped = !_isFlipped;
                });
              },
              child: const Text('Flip'),
            ),
          ],
        ),
      ),
    );
  }
}
