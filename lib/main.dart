import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:object_detection_ai/theme/apptheme.dart';
import 'package:object_detection_ai/theme/theme_provider.dart';
import 'package:object_detection_ai/ui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyD0Bd0ARldle8V3RraayyZkm3LP5yCOcY4');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: lightMode,
      darkTheme: darkMode,
      home: SplashScreen(),
    );
  }
}
