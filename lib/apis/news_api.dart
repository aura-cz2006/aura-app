import 'dart:convert';

import 'package:aura/config/config.dart';
import 'package:aura/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

class NewsApi {
  static Future<List<NewsItem>> fetchNews() async {
    Uri url = Uri.parse("${Config().routes["api"]}/news");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;

      // use dart:convert to decode JSON
      List<dynamic> decodedJson = json.decode(responseBody);

      List<NewsItem> resList = decodedJson
          .map((item) {
            switch (item['newstype']) {
              case 'dengue':
                return DengueNewsItem.getFromJson(item);
              case 'ccEvents':
                return EventNewsItem.getFromJson(item);
              case 'marketClosure':
                return MarketNewsItem.getFromJson(item);
              case 'upgradingWorks':
                return UpgradingNewsItem.getFromJson(item);
              default:
                return null;
            }
          })
          .where((newsItem) => newsItem != null)
          .cast<NewsItem>()
          .toList();

      return resList;
    } else {
      print(
          "ERROR fetching news: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }
}
