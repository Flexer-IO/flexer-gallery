import 'package:flutter/material.dart';

class GskinnerteamFlutterVignettesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(150),
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
          width: 300,
          height: 300,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InteractiveVignettePage()),
          );
        },
        tooltip: 'Interactive Vignette',
        child: const Icon(Icons.open_in_new),
      ),
    );
  }
}

class InteractiveVignettePage extends StatefulWidget {
  const InteractiveVignettePage({super.key});

  @override
  _InteractiveVignettePageState createState() => _InteractiveVignettePageState();
}

class _InteractiveVignettePageState extends State<InteractiveVignettePage> {
  double _vignetteFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(150),
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              stops: [
                _vignetteFraction,
                _vignetteFraction + 0.1,
              ],
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
          width: 300,
          height: 300,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _vignetteFraction = _vignetteFraction - 0.1;
                if (_vignetteFraction < 0) {
                  _vignetteFraction = 0;
                }
              });
            },
            tooltip: 'Decrease Vignette',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _vignetteFraction = _vignetteFraction + 0.1;
                if (_vignetteFraction > 1) {
                  _vignetteFraction = 1;
                }
              });
            },
            tooltip: 'Increase Vignette',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}