import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevBlog',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF38BDF8), // Sky blue
          secondary: const Color(0xFF818CF8),
          surface: const Color(0xFF1E293B), // Slate 800
        ),
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}