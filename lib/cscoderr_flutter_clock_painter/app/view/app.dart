import 'package:flutter/material.dart';
// import '../../../../deps/flutter_gen/app_localizations.dart';
import '../../clock/clock.dart';

class AppLocalizations {
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [];
  static const List<Locale> supportedLocales = [];
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ClockPage(),
    );
  }
}