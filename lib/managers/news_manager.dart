import 'dart:collection';
import 'package:aura/util/manager.dart';
import 'package:aura/models/news.dart';
import 'package:latlong2/latlong.dart';

class News_Manager extends Manager {
  List<NewsItem> _newsList = [];

  UnmodifiableListView<NewsItem> get newsList =>
      UnmodifiableListView(_newsList);

  void setNews(List<NewsItem> news) {
    _newsList = news;
    _newsList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    notifyListeners();
  }

  List<NewsItem> getNowNewsItems() {
    return _newsList
        .where((n) =>
            n.dateTime.isBefore(DateTime.now()) || n.dateTime == DateTime.now())
        .toList();
  }

  List<NewsItem> getUpcomingNewsItems() {
    return _newsList.where((n) => n.dateTime.isAfter(DateTime.now())).toList();
  }

}
