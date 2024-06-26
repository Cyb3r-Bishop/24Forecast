import 'package:flutter/material.dart';
import 'package:my_meather/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      //home: const WeatherScreen(),
      home: const HomeScreen(),
    );
  }
}
