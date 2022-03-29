import 'dart:collection';
import 'package:aura/util/manager.dart';
import 'package:aura/models/news.dart';
import 'package:latlong2/latlong.dart';

class News_Manager extends Manager {
  List<NewsItem> _newsList = [
    // todo replace LatLng
    // UpgradingNewsItem(DateTime(2022, 1, 1), LatLng(0, 0),
    //     "Repainting at Block 1 Dover Road", DateTime(2022, 3, 31)),
    // MarketNewsItem(DateTime(2022, 10, 11), LatLng(0, 0),
    //     "Blk 17 Upper Boon Keng Market and Food Centre", DateTime(2022, 11, 1)),
    // EventNewsItem(DateTime(2022, 3, 5), LatLng(0, 0),
    //     "intro to chromatic harmonica", 10, "https://www.onepa.gov.sg/events"),
    // DengueNewsItem(DateTime.now(), LatLng(0, 0), 3),
    // UpgradingNewsItem(DateTime(2022, 3, 1), LatLng(0, 0),
    //     "Beside Block 268C Boon Lay Drive", DateTime(2022, 6, 31)),
    // MarketNewsItem(DateTime(2022, 1, 10), LatLng(0, 0),
    //     "Telok Blangah Rise Market", DateTime(2022, 1, 21)),
    // EventNewsItem(
    //     DateTime(2022, 3, 19),
    //     LatLng(0, 0),
    //     "Jurong Spring IRCC Getai Nite 2022",
    //     8,
    //     "https://www.onepa.gov.sg/events"),
    // DengueNewsItem(DateTime.now(), LatLng(0, 0), 2),
    // UpgradingNewsItem(
    //     DateTime(2022, 6, 1),
    //     LatLng(0, 0),
    //     "Lighting upgrading at Block 209 Boon Lay Place",
    //     DateTime(2022, 8, 31)),
    // MarketNewsItem(DateTime(2022, 1, 10), LatLng(0, 0),
    //     "Toa Payoh Lorong 8 Blk 210", DateTime(2022, 1, 11)),
    // EventNewsItem(
    //     DateTime(2022, 1, 15),
    //     LatLng(0, 0),
    //     "Nanyang Shoe Recycling Drive Donation 2022",
    //     0,
    //     "https://www.onepa.gov.sg/events"),
    // DengueNewsItem(DateTime.now(), LatLng(0, 0), 7),
  ];

  UnmodifiableListView<NewsItem> get newsList =>
      UnmodifiableListView(_newsList);

  void setNews(List<NewsItem> news) {
    _newsList = news;

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
