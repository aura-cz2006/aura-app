import 'package:aura/controllers/news_controller.dart';
import 'package:aura/managers/news_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/models/news.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../community/fabLocation.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<NewsItem>? newsToDisplay;
  List<Tab> tabs = const [
    Tab(text: 'Now'),
    Tab(text: 'Upcoming'),
  ];

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<User_Manager,News_Manager>(builder: (context, userMgr, newsMgr, child) {

      Future<void> _handleRefresh () async {
        NewsController.fetchNews(context);
      }

      return DefaultTabController(
        length: tabs.length,
        // The Builder widget is used to have a different BuildContext to access
        // closest DefaultTabController.
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context)!;
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                setState(() {
                  if (tabController.index == 0) {
                    newsToDisplay = newsMgr.getNowNewsItems(userMgr.location_data);
                  } else if (tabController.index == 1) {
                    newsToDisplay = newsMgr.getUpcomingNewsItems(userMgr.location_data);
                  }
                });
              }
            });
            return Scaffold(
                floatingActionButton: locationFABWrap(),
                appBar: AuraAppBar(
                  title: const Text("News"),
                  hasBackButton: false,
                  bottom: TabBar(tabs: tabs),
                ),
                body: LiquidPullToRefresh(
                  key: _refreshIndicatorKey,
                  color: Colors.grey[200],
                  backgroundColor: Colors.redAccent,
                  showChildOpacityTransition: false,
                  height: 75,
                  animSpeedFactor: 3,
                  onRefresh: _handleRefresh,
                  // method that calls controller to "set" data in manager
                  child: // scroll view
                      ListView(
                    scrollDirection: Axis.vertical,
                    children: ((newsToDisplay == null)
                            ? newsMgr.getNowNewsItems(userMgr.location_data)
                            : newsToDisplay!)
                        .map((n) => Card(
                              child: ListTile(
                                leading: Icon(
                                  n is DengueNewsItem
                                      ? DengueNewsItem.getIcon()
                                      : n is DengueNewsItem
                                          ? DengueNewsItem.getIcon()
                                          : n is EventNewsItem
                                              ? EventNewsItem.getIcon()
                                              : n is MarketNewsItem
                                                  ? MarketNewsItem.getIcon()
                                                  : n is UpgradingNewsItem
                                                      ? UpgradingNewsItem
                                                          .getIcon()
                                                      : NewsItem.getIcon(),
                                  size: 30,
                                ),
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(n.getNewsTitle(),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(n.getNewsDetails(),
                                              style: const TextStyle(
                                                  fontSize: 15))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          DateFormat('yyyy-MM-dd kk:mm')
                                              .format(n.dateTime),
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ]),
                              ),
                            ))
                        .toList(),
                  ),
                ));
          },
        ),
      );
    });
  }
}
