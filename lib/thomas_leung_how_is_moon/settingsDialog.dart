import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stub for MoonIcons when the original library is unavailable.
/// This provides the minimal API used in this file.
class MoonIcons {
  static const IconData moon = Icons.brightness_2;
}

class SettingDialog extends StatefulWidget {
  final void Function(String, dynamic) callback;
  const SettingDialog(this.callback, {Key? key}) : super(key: key);

  @override
  _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  bool showSat = false;
  bool showAst = false;
  String astAnime = 'flash';

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Future<void> getSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showSat = prefs.getBool('showSat') ?? false;
      showAst = prefs.getBool('showAst') ?? false;
      astAnime = prefs.getString('astAnime') ?? 'flash';
    });
  }

  Future<void> setSharedPref(String key, Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == "astAnime") {
      await prefs.setString(key, value as String);
    } else {
      await prefs.setBool(key, value as bool);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Card(
        child: Container(
          height: 400,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  "Setting",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white38,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: const Text('Show Satellite'),
                        value: showSat,
                        onChanged: (bool value) {
                          setSharedPref('showSat', value);
                          setState(() {
                            showSat = value;
                          });
                          widget.callback('showSat', showSat);
                        },
                        secondary: const Icon(Icons.airplanemode_active),
                      ),
                      SwitchListTile(
                        title: const Text('Show Astronaut'),
                        value: showAst,
                        onChanged: (bool value) {
                          setSharedPref('showAst', value);
                          setState(() {
                            showAst = value;
                          });
                          widget.callback('showAst', showAst);
                        },
                        secondary: const Icon(Icons.accessibility_new),
                      ),
                      ListTile(
                        leading: const Icon(Icons.touch_app),
                        title: const Text("Astronaut when tap"),
                        subtitle: const Text(
                          "*Work best when device is in portrait mode.",
                          style: TextStyle(fontSize: 10),
                        ),
                        enabled: showAst,
                        trailing: DropdownButton<String>(
                          value: astAnime,
                          onChanged: showAst
                              ? (String? value) {
                                  if (value != null) {
                                    setSharedPref('astAnime', value);
                                    setState(() {
                                      astAnime = value;
                                    });
                                    widget.callback('astAnime', astAnime);
                                  }
                                }
                              : null,
                          items: <String>['flash', 'float', 'phone', 'walk']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("More Info"),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationIcon: const Icon(MoonIcons.moon),
                            applicationName: "How's Moon",
                            applicationVersion: '1.0.0',
                            children: <Widget>[
                              const Text(
                                "A minimalistic moon phase calculator combined with a digital clock.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const Text(
                                "\u207A Moon phase is an estimation, there could be +/- a day difference.",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Made with 🍜 by Thomas.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const Text(
                                "\u00a9 2020 Thomas",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}