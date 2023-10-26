import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true), // light theme
      darkTheme: ThemeData.dark(useMaterial3: true), // dark theme
      // themeMode -: Control the theme according to device settings.
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
