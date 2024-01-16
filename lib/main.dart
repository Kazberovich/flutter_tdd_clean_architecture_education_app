import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/res/fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TDD Education App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colours.primaryColour,
        ),
        useMaterial3: true,
        fontFamily: Fonts.popins,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Colors.transparent),
      ),
      home: const Scaffold(),
    );
  }
}
