import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/view/community/community_tab.dart';
import 'package:aura/view/map/map_tab.dart';
import 'package:aura/view/news/news_tab.dart';
import 'package:aura/view/map/amenitieschip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              actionsIconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          tabBarTheme: TabBarTheme(
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent),
            unselectedLabelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black, // ! doesn't work
            ),
          ),
          primarySwatch: Colors.red,
          navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.white,
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decorationColor: Colors.red)))),
      home: const TabBar(),
    );
  }
}

/* Navigation Tab Bar */
class TabBar extends StatefulWidget {
  const TabBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  int selectedIndex = 1; // start at map by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: const <Widget>[
            CommunityTab(),
            MapTab(),
            NewsTab(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.groups),
                icon: Icon(Icons.groups_outlined),
                label: 'Community',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.map),
                icon: Icon(Icons.map_outlined),
                label: 'Map',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.podcasts),
                icon: Icon(Icons.podcasts_outlined),
                label: 'News',
              ),
            ]));
  }
}
