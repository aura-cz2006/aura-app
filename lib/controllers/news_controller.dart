

import 'package:aura/apis/news_api.dart';
import 'package:aura/managers/news_manager.dart';
import 'package:aura/models/news.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class NewsController {
  static void fetchNews(BuildContext context) async {

    // todo: call api - convert to dart there
    // todo: receive api data from api handler

    List<NewsItem> fetchedNewsItems = await NewsApi.fetchNews();

    // call provider here

    Provider.of<News_Manager>(context, listen: false).setNews(
        fetchedNewsItems
      // [
        //   UpgradingNewsItem(DateTime(2022, 1, 1), LatLng(0, 0),
        //       "Repainting at Block 5 Dover Road", DateTime(2022, 3, 31)),
        //   MarketNewsItem(DateTime(2022, 10, 11), LatLng(0, 0),
        //       "Blk 17 Upper Boon Keng Market and Food Centre", DateTime(2022, 11, 1)),
        //   EventNewsItem(DateTime(2022, 3, 5), LatLng(0, 0),
        //       "intro to chromatic harmonica", 10, "https://www.onepa.gov.sg/events"),
        // ]
    );

  }
}