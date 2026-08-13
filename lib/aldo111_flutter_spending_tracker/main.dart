import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants/app_colors.dart' as app_colors;
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const dummyAvatarUrl =
      'https://st2.depositphotos.com/2703645/5669/v/950/depositphotos_56695433-stock-illustration-female-avatar.jpg';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: app_colors.AppColors.primaryWhiteColor,
        scaffoldBackgroundColor: app_colors.AppColors.primaryWhiteColor,
        colorScheme: const ColorScheme.light(
          secondary: Color(0xFFCADCF8),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: app_colors.AppColors.headerTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          displayMedium: TextStyle(
            color: app_colors.AppColors.headerTextColor,
            fontSize: 24,
          ),
          displaySmall: TextStyle(
            color: app_colors.AppColors.primaryWhiteColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCADCF8),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: app_colors.AppColors.darkModeBackground,
        scaffoldBackgroundColor: Colors.red,
        colorScheme: const ColorScheme.dark(
          secondary: app_colors.AppColors.darkModeBackground,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: app_colors.AppColors.primaryWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          displayMedium: TextStyle(
            color: app_colors.AppColors.primaryWhiteColor,
            fontSize: 24,
          ),
          displaySmall: TextStyle(
            color: app_colors.AppColors.primaryWhiteColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: app_colors.AppColors.darkModeBackground,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            CircleAvatar(
              backgroundImage: NetworkImage(dummyAvatarUrl),
              radius: 24,
            ),
            const SizedBox(width: 24),
          ],
        ),
        body: Stack(
          children: [
            HomeScreen(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(
                      Icons.list_alt,
                      size: 28,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.local_offer_outlined, size: 28),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person, size: 28),
                    label: '',
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