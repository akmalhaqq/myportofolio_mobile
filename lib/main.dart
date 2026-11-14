import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7EA87A),
          brightness: Brightness.dark,
          surface: const Color(0xFF12181F),
          onSurface: const Color(0xFFF2F0E8),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
