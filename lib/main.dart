import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:aura/globals.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/news_manager.dart';
import 'managers/notification_manager.dart';
import 'managers/thread_manager.dart';
import 'managers/meetup_manager.dart';

Future initMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();
}


void main() async {
  // for zoned errors https://firebase.flutter.dev/docs/crashlytics/usage#zoned-errors
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logAppOpen();

    // load shareprefs as global vars
    await initMain();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MapManager()),
          ChangeNotifierProvider(create: (context) => NotificationManager()),
          ChangeNotifierProvider(create: (context) => Thread_Manager()),
          ChangeNotifierProvider(create: (context) => Meetup_Manager()),
          ChangeNotifierProvider(create: (context) => User_Manager()),
          ChangeNotifierProvider(create: (context) => News_Manager()),
          ChangeNotifierProvider(create: (context) => News_Manager()),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aura',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              actionsIconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w800)),
          tabBarTheme: TabBarTheme(
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Colors.redAccent),
            ),
            labelColor: Colors.red,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            unselectedLabelColor: Colors.grey[400],
            unselectedLabelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          primarySwatch: Colors.red,
          navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.white,
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decorationColor: Colors.red)))),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
