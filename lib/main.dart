import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as uiauth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:tdd_education_app/core/common/app/providers/notifications_notifier.dart';
import 'package:tdd_education_app/core/common/app/providers/user_provider.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/res/fonts.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/core/services/router.dart';
import 'package:tdd_education_app/firebase_options.dart';
import 'package:tdd_education_app/src/dashboard/presentation/providers/dashboard_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  uiauth.FirebaseUIAuth.configureProviders([uiauth.EmailAuthProvider()]);
  // TODO(sergey): remove-once_logout-is-implemented.
  // TODO(sergey): message, https://stackoverflow.com/questions/4747404/delete-keychain-items-when-an-app-is-uninstalled.
  //await FirebaseAuth.instance.signOut();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => CourseOfTheDayNotifier()),
        ChangeNotifierProvider(
          create: (_) =>
              NotificationsNotifier(serviceLocator<SharedPreferences>()),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
