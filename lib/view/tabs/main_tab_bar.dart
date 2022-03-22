import 'package:flutter/material.dart';
import 'package:aura/view/tabs/community/community_tab.dart';
import 'package:aura/view/tabs/map/map_tab.dart';
import 'package:aura/view/tabs/news/news_tab.dart';
import 'package:go_router/go_router.dart';
/* Navigation Tab Bar */

const tabs = {0: "community", 1: "map", 2: "news"};

class MainTabBar extends StatefulWidget {
  final String currentTab;

  const MainTabBar({Key? key, required this.currentTab}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = tabs.entries
        .firstWhere((element) => element.value == widget.currentTab)
        .key;

    void changeTab(String newTabName) {
      GoRouter.of(context).go("/tabs/$newTabName");
    }

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Aura'),
        //   backgroundColor: Colors.blue,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: const Icon(
        //         Icons.settings,
        //         color: Colors.black54,
        //       ),
        //       onPressed: () {
        //         GoRouter.of(context).push("/settings");
        //       },
        //     )
        //   ],
        // ),
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
              changeTab(tabs[index]!);
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
