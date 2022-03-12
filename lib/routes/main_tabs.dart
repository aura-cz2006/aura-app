import 'package:flutter/material.dart';
import 'package:aura/view/community/community_tab.dart';
import 'package:aura/view/map/map_tab.dart';
import 'package:aura/view/news/news_tab.dart';

/* Navigation Tab Bar */
class MainTabBar extends StatefulWidget {
  const MainTabBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabBarState();
}


class _TabBarState extends State<TabBar> {
  int selectedIndex = 0;

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
