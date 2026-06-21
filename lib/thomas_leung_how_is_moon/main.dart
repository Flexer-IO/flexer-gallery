import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Placeholder implementations for missing dependencies.

class AnimationControls {
  void updateMoonPhase(double diff) {}
}

class FlareActor extends StatelessWidget {
  final String asset;
  final AnimationControls? controller;
  final BoxFit? fit;
  final String? animation;
  final String? artboard;

  const FlareActor(
    this.asset, {
    Key? key,
    this.controller,
    this.fit,
    this.animation,
    this.artboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
}

class Astronaut extends StatelessWidget {
  final String anime;
  const Astronaut(this.anime, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container();
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container();
}

class MoonTitle extends StatelessWidget {
  final DateTime date;
  const MoonTitle(this.date, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container();
}

class Moon {
  int calculateMoonPhase(int year, int month, int day) => 0;
}

class EarthPage extends StatelessWidget {
  final double diff;
  const EarthPage(this.diff, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container();
}

class SettingDialog extends StatelessWidget {
  final void Function(String, dynamic) callback;
  const SettingDialog(this.callback, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container();
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<MainPage> with SingleTickerProviderStateMixin {
  DateTime _date = DateTime.now();
  String brNav = "Today's Moon";

  late AnimationControls _flareController;
  late AnimationController _flutterController;

  int currentMoonPhase = 0;
  int selectedMoon = 29;
  bool tapSat = false;
  bool showSat = false;
  bool showAst = false;
  bool showClock = true;
  DateTime newDate = DateTime.now();
  double diff = 0.0;
  double _scale = 1.0;
  String astAnime = "flash";

  @override
  void initState() {
    super.initState();
    _flareController = AnimationControls();
    int moonDay = Moon().calculateMoonPhase(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _incrementMoon(moonDay);
    getSharedPref();

    _flutterController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 80),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
  }

  void _incrementMoon(int amount) {
    currentMoonPhase = amount;
    diff = currentMoonPhase / selectedMoon;
    _flareController.updateMoonPhase(diff);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1970, 1, 7),
        lastDate: DateTime(2200));

    if (selectedDate != null && selectedDate != _date) {
      int moonDay = Moon().calculateMoonPhase(
          selectedDate.year, selectedDate.month, selectedDate.day);
      setState(() {
        _date = selectedDate;
        newDate = selectedDate;
        if (DateFormat('yyyy-MM-dd').format(selectedDate) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          brNav = "Today's Moon";
        } else {
          brNav = DateFormat('yyyy-MM-dd').format(selectedDate).toString();
        }
        _incrementMoon(moonDay);
      });
    }
  }

  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showSat = prefs.getBool('showSat') ?? false;
      showAst = prefs.getBool('showAst') ?? false;
      astAnime = prefs.getString('astAnime') ?? "flash";
    });
  }

  // Pass this method to settings dialog to change value in parent (main.dart)
  void settingCallback(String setting, dynamic newState) {
    setState(() {
      if (setting == 'showSat') {
        showSat = newState as bool;
      } else if (setting == 'showAst') {
        showAst = newState as bool;
      } else {
        astAnime = newState as String;
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    _flutterController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _flutterController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _flutterController.value;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showClock = !showClock;
                  });
                },
                child: Container(
                  child: showClock ? const Clock() : MoonTitle(newDate),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      child: Transform.scale(
                        scale: _scale,
                        child: FlareActor(
                          "packages/showcase_library/assets/thomas_leung_how_is_moon/Moon.flr",
                          controller: _flareController,
                          fit: BoxFit.contain,
                          animation: 'idle',
                          artboard: "Artboard",
                        ),
                      ),
                    ),
                    showAst ? Astronaut(astAnime) : Container(),
                    Positioned(
                      top: -25,
                      right: 20,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          setState(() {
                            tapSat = !tapSat;
                          });
                        },
                        child: showSat
                            ? Container(
                                height: 150,
                                width: 120,
                                child: FlareActor(
                                  'packages/showcase_library/assets/thomas_leung_how_is_moon/Satellite.flr',
                                  fit: BoxFit.contain,
                                  animation: tapSat ? 'touch' : 'idle',
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'earthIcon',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EarthPage(diff)));
        },
        backgroundColor: const Color.fromRGBO(5, 40, 62, 1.0),
        child: Image.asset(
            'packages/showcase_library/assets/thomas_leung_how_is_moon/earth.png'),
      ),
      backgroundColor: const Color.fromRGBO(5, 40, 62, 1.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              child: const Text("How's Moon in: "),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => SettingDialog(settingCallback),
                );
              },
            ),
            TextButton(
              child: Text(brNav),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}