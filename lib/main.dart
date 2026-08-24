import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AkiliApp());
}

class AkiliApp extends StatelessWidget {
  const AkiliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akili TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
