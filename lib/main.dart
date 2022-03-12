import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/routes/main_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DiscussionManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const MainTabBar(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationParser: _router.routeInformationParser,
    routerDelegate: _router.routerDelegate,
  );

  // // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Aura',
  //     theme: ThemeData(
  //         appBarTheme: const AppBarTheme(
  //             backgroundColor: Colors.white,
  //             elevation: 0,
  //             actionsIconTheme: IconThemeData(color: Colors.black),
  //             titleTextStyle: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold)),
  //         tabBarTheme: TabBarTheme(
  //           labelStyle:
  //               const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //           indicator: BoxDecoration(
  //               borderRadius: BorderRadius.circular(50),
  //               color: Colors.redAccent),
  //           unselectedLabelStyle: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.black, // ! doesn't work
  //           ),
  //         ),
  //         primarySwatch: Colors.red,
  //         navigationBarTheme: NavigationBarThemeData(
  //             backgroundColor: Colors.white,
  //             labelTextStyle: MaterialStateProperty.all(const TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 decorationColor: Colors.red)))),




        // routes: <String, WidgetBuilder>{
        //   '/': (BuildContext context) => const MainTabBar(),
        //   '/notifications': (BuildContext context) => NotificationsScreen(),
        //   '/settings': (BuildContext context) => SettingsScreen(),
        // }
  //   );
  // }
}

