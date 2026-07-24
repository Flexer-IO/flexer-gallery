import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Stub implementations for missing Rive classes (to ensure null‑safe
// compilation with Dart 3). These are only needed when the actual
// `rive` package does not expose the referenced symbols.
// ---------------------------------------------------------------------------

/// Minimal stub for [Artboard] when the real class is unavailable.
class Artboard {
  void addController(StateMachineController controller) {}
}

/// Minimal stub for [StateMachineController] when the real class is unavailable.
class StateMachineController {
  final List<dynamic> inputs = [];

  StateMachineController();

  static StateMachineController? fromArtboard(
    Artboard artboard,
    String name,
  ) =>
      StateMachineController();
}

/// Minimal stub for [RiveFile] when the real class is unavailable.
class RiveFile {
  final Artboard mainArtboard;

  RiveFile(this.mainArtboard);

  static RiveFile import(Uint8List data) => RiveFile(Artboard());
}

/// Minimal stub for the [RiveAnimation] widget when the real widget is unavailable.
class RiveAnimation extends StatelessWidget {
  const RiveAnimation.direct({
    Key? key,
    required this.artboard,
    this.fit,
  }) : super(key: key);

  final Artboard artboard;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ---------------------------------------------------------------------------

class TeddyLoginScreen extends StatefulWidget {
  const TeddyLoginScreen({Key? key}) : super(key: key);

  @override
  State<TeddyLoginScreen> createState() => _TeddyLoginScreenState();
}

class _TeddyLoginScreenState extends State<TeddyLoginScreen> {
  late String animationURL;
  Artboard? _teddyArtboard;
  dynamic successTrigger, failTrigger;
  dynamic isHandsUp, isChecking;
  dynamic numLook;

  bool _isChecked = false;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationURL = defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/animations/login.riv'
        : 'animations/login.riv';
    rootBundle.load(animationURL).then(
      (ByteData data) {
        final file = RiveFile.import(data.buffer.asUint8List());
        final artboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(artboard, "Login Machine");
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);

          for (var e in stateMachineController!.inputs) {
            debugPrint(e.runtimeType.toString());
            debugPrint("name${e.name}End");
          }

          for (var element in stateMachineController!.inputs) {
            if (element.name == "trigSuccess") {
              successTrigger = element;
            } else if (element.name == "trigFail") {
              failTrigger = element;
            } else if (element.name == "isHandsUp") {
              isHandsUp = element;
            } else if (element.name == "isChecking") {
              isChecking = element;
            } else if (element.name == "numLook") {
              numLook = element;
            }
          }
        }

        setState(() => _teddyArtboard = artboard);
      },
    );
  }

  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBalls(String val) {
    numLook?.change(val.length.toDouble());
  }

  void login() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (_emailController.text == "admin@gmail.com" &&
        _passwordController.text == "admin") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_teddyArtboard != null)
              SizedBox(
                width: 400,
                height: 300,
                child: RiveAnimation.direct(
                  artboard: _teddyArtboard!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            Container(
              alignment: Alignment.center,
              width: 400,
              padding: const EdgeInsets.only(bottom: 15),
              margin: const EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15 * 2),
                        TextField(
                          controller: _emailController,
                          onTap: lookOnTheTextField,
                          onChanged: moveEyeBalls,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: const Color(0xffb04863),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: Color(0xffb04863),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb04863),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          onTap: handsOnTheEyes,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: GoogleFonts.poppins(fontSize: 14),
                          cursorColor: const Color(0xffb04863),
                          decoration: const InputDecoration(
                            hintText: "Password",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusColor: Color(0xffb04863),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb04863),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: const Color(0xffb04863),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "Remember me",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffb04863),
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}