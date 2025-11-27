import 'package:flutter/material.dart';
import 'screens/home_screens.dart';

void main() {
  runApp(const BookVerseApp());
}

class BookVerseApp extends StatefulWidget {
  const BookVerseApp({super.key});

  @override
  State<BookVerseApp> createState() => _BookVerseAppState();
}

class _BookVerseAppState extends State<BookVerseApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  ThemeData get _darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFe50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFe50914),
          secondary: Color(0xFFff5670),
        ),
        scaffoldBackgroundColor: const Color(0xFF050509),
        cardColor: const Color(0xFF18181f),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      );

  ThemeData get _lightTheme => ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFff5c7a), 
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFff5c7a),
        secondary: Color(0xFFffb86c),       
      ),
      scaffoldBackgroundColor: const Color(0xFFFDF5FF), 
      cardColor: Colors.white,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1D1325),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D1325),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF493a55),
        ),
      ),
    );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookVerse',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
