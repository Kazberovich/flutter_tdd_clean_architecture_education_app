import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/res/fonts.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/core/services/router.dart';

import 'package:tdd_education_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
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
      onGenerateRoute: generateRoute,
    );
  }
}
