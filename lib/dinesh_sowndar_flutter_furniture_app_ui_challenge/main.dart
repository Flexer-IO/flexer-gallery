import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home/home_page.dart';
import 'deps/google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Furnitures App',
      theme: ThemeData(
          primaryColor: const Color(0xFF5245FE),
          // fontFamily: 'Poppins',
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: const HomePage(),
    );
  }
}
