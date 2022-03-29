import 'package:aura/managers/news_manager.dart';
import 'package:aura/models/news.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<NewsItem> newsToDisplay = [];
  List<Tab> tabs = const [
    Tab(text: 'Now'),
    Tab(text: 'Upcoming'),
  ];

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<News_Manager>(builder: (context, newsMgr, child) {

      Future<void> _handleRefresh () async {
        // todo: call api handler

        NewsController.fetchNews(context);
        // newsMgr.setNews(
        //   [
        //     UpgradingNewsItem(DateTime(2022, 1, 1), LatLng(0, 0),
        //         "Repainting at Block 1 Dover Road", DateTime(2022, 3, 31)),
        //     MarketNewsItem(DateTime(2022, 10, 11), LatLng(0, 0),
        //         "Blk 17 Upper Boon Keng Market and Food Centre", DateTime(2022, 11, 1)),
        //     EventNewsItem(DateTime(2022, 3, 5), LatLng(0, 0),
        //         "intro to chromatic harmonica", 10, "https://www.onepa.gov.sg/events"),
        //   ]
        // );
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
              //todo fix
              if (!tabController.indexIsChanging) {
                setState(() {
                  if (tabController.index == 0) {
                    newsToDisplay = newsMgr.getNowNewsItems();
                  } else if (tabController.index == 1) {
                    newsToDisplay = newsMgr.getUpcomingNewsItems();
                  }
                });
              }
            });
            return Scaffold(
                appBar: AuraAppBar(
                  title: const Text("News"),
                hasBackButton: false,
                bottom: TabBar(tabs: tabs),
              ),
              body: LiquidPullToRefresh(
                  key: _refreshIndicatorKey, // key if you want to add
                  onRefresh: _handleRefresh, // refresh callback
                  child: // scroll view

                      ListView(
                    scrollDirection: Axis.vertical,
                    children: (newsToDisplay.isEmpty
                            ? newsMgr.getNowNewsItems()
                            : newsToDisplay)
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
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(n.getText(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(DateFormat('yyyy-MM-dd kk:mm')
                                      .format(n.dateTime)),
                                ),
                                onTap: () {
                                  final popup = BeautifulPopup(
                                    //TODO populate w related data by type of news item
                                    context: context,
                                    template: TemplateGeolocation,
                                  );
                                  popup.show(
                                    title: "News Details",
                                    content: n.getText(),
                                    actions: n is EventNewsItem
                                        ? [
                                            //todo make these buttons vertical stack instead of horizontal row
                                            popup.button(
                                                label: 'Redirect',
                                                onPressed: () async {
                                                  if (!await launch(
                                                      n.websiteURL)) {
                                                    throw 'Could not launch ${n.websiteURL}';
                                                  }
                                                }),
                                            popup.button(
                                              label: 'Done',
                                              onPressed: Navigator.of(context)
                                                  .pop, //todo switch to go router
                                            )
                                          ]
                                        : [
                                            popup.button(
                                              label: 'Done',
                                              onPressed: Navigator.of(context)
                                                  .pop, //todo switch to go router
                                            )
                                          ],
                                  );
                                },
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
