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
      // dynamic decodedJson = json.decode(responseBody); // todo put this back

      Map<String, dynamic> decodedJson = { // todo take this test data out
        'news': [
          {
            "id": "1",
            "newstype": "dengue",
            "date": "2019-12-04T00:00:00",
            "numCases": 69
          },
          {
            "id": "2",
            "newstype": "ccEvents",
            "date": "2019-12-04T00:00:00",
            "eventTitle": "Jamie's birthday party",
            "url": "instagram.com",
            "fee": "FREE!!!"
          },
          {
            "id": "3",
            "newstype": "marketClosure",
            "date": "2019-12-04T00:00:00",
            "marketName": "Hougang Wet Market",
            "reopeningDate": "2019-12-16T00:00:00"
          },
          {
            "id": "4",
            "newstype": "upgradingWorks",
            "date": "2019-12-04T00:00:00",
            "desc": "Upgrading of lifts at Aljunied Block 27",
            "endDate": "2019-12-27T00:00:00"
          }
          // {
          //   'id': '1',
          //   'type': 'dengue',
          //   'datetime': '2020-01-21 07:21:06',
          //   'location': [0.0, 1.0],
          //   'numCases': 5
          // },
          // {
          //   'id': '2',
          //   'type': 'event',
          //   'datetime': '2022-04-07 12:30',
          //   'location': [0.0, 1.0],
          //   'eventTitle': 'VERY EXCITING THINGS ARE HAPPENING',
          //   'fee': 9.99,
          //   'websiteURL': 'http://api.aura-app.xyz/docs'
          // },
          // {
          //   'id': '3',
          //   'type': 'market',
          //   'datetime': '2022-01-21 07:21:06',
          //   'location': [0.0, 1.0],
          //   'market': 'big market',
          //   'reopeningDate': '2022-03-25 07:21:06'
          // },
          // {
          //   'id': '4',
          //   'type': 'upgrading',
          //   'datetime': '2023-01-21 08:21:06',
          //   'location': [0.0, 1.0],
          //   'description': 'big fixes',
          //   'end': '2023-06-21 07:21:06'
          // }
        ]
      };

      List<NewsItem> resList = (decodedJson['news'] as List)
          .map((item) {
            switch (item['newstype']) {
              case 'dengue': // todo replace w enum names
                return DengueNewsItem.getFromJson(item);
              case 'ccEvents': // todo replace w enum names
                return EventNewsItem.getFromJson(item);
              case 'marketClosure': // todo replace w enum names
                return MarketNewsItem.getFromJson(item);
              case 'upgradingWorks': // todo replace w enum names
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
