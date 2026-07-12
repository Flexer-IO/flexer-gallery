import 'package:audioplayers/audioplayers.dart';
import '../../game/game.dart';
import '../../loading/loading.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';

/// Stub for the generated localization class when the generated file is
/// unavailable. This provides the minimal API used in this file.
class AppLocalizations {
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [];
  static const List<Locale> supportedLocales = [];
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PreloadCubit(
            Images(prefix: ''),
            AudioCache(prefix: ''),
          )..loadSequentially(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9E0AFF),
        ),
        textTheme: GoogleFonts.macondoTextTheme(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // home: const LoadingPage(),
      home: const GamePage(),
    );
  }
}