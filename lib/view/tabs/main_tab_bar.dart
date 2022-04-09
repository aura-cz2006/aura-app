import 'package:aura/view/map/mapbox_tab.dart';
import 'package:aura/view/onboarding/introduction_page_view.dart';
import 'package:flutter/material.dart';
import 'package:aura/view/tabs/community/community_tab.dart';
import 'package:aura/view/tabs/map/map_tab.dart';
import 'package:aura/view/tabs/news/news_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/meetups_controller.dart';
import '../../controllers/news_controller.dart';
import '../../controllers/thread_controller.dart';
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
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = tabs.entries
        .firstWhere((element) => element.value == widget.currentTab)
        .key;

    void changeTab(String newTabName) {
      setState(() {
        print(newTabName);
        if (newTabName == 'community'){
          print("===============INITIALIZING MEETUPS====================");
          MeetupsController.fetchMeetups(context);
          print("=============EXITED MEETUP INTIALIZATION & ENTERING THREAD INITIALIZATION================");
          ThreadController.fetchThreads(context);
          print("===========EXITED THREAD INITIALIZATION============");
        }
        if (newTabName == 'news'){
          NewsController.fetchNews(context); // get initial
        }
      });
      GoRouter.of(context).go("/tabs/$newTabName");
    }

    return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: const <Widget>[
            CommunityTab(),
            MapboxTab(),
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
