import 'dart:collection';
import 'package:aura/util/manager.dart';
import 'package:aura/models/news.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:provider/provider.dart';

class News_Manager extends Manager {
  List<NewsItem> newsList = [];

  void setNews(List<NewsItem> news) {
    newsList = news;
    newsList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    notifyListeners();
  }

  List<NewsItem> getNowNewsItems(LatLng curr_user_address) {
    // List<NewsItem> updatedNewsListbyDistance = [];
    // Distance distance = Distance();
    // for (NewsItem news in newsList) {
    //   double meter = distance(curr_user_address, news.location);
    //   if (meter < 4000) {
    //     updatedNewsListbyDistance.add(news);
    //   }
    // }
    // return updatedNewsListbyDistance
    return newsList
        .where((n) =>
            n.dateTime.isBefore(DateTime.now()) || n.dateTime == DateTime.now())
        .toList();
  }

  List<NewsItem> getUpcomingNewsItems(LatLng curr_user_address) {
    // List<NewsItem> updatedNewsListbyDistance = [];
    // Distance distance = Distance();
    // for (NewsItem news in newsList) {
    //   double meter = distance(curr_user_address, news.location);
    //   if (meter < 4000) {
    //     updatedNewsListbyDistance.add(news);
    //   }
    // }
    // return updatedNewsListbyDistance.where((n) => n.dateTime.isAfter(DateTime.now())).toList();
    return newsList
        .where((n) =>
    n.dateTime.isBefore(DateTime.now()) || n.dateTime == DateTime.now())
        .toList();
  }
}
