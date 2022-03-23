import 'package:flutter/material.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsTabState();
}

const List<Tab> tabs = <Tab>[
  Tab(text: 'Now'),
  Tab(text: 'Upcoming'),
];

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const TabBar(
              tabs: [
                Tab(text: "Current"),
                Tab(text: "Upcoming"),
                //more tabs here
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.settings_outlined))
            ],
          ),
          body: const Center(
            child: Text("newsTab"),
          ),
        );
      }),
    );
  }
}
