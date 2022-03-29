import 'dart:convert';

import 'package:aura/config/config.dart';
import 'package:aura/models/news.dart';
import 'package:http/http.dart' as http; // for making HTTP calls

class NewsApi {
  static Future<List<NewsItem>> fetchNews() async {
    Uri url = Uri.parse("${Config().routes["api"]}/news");

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      // the response body
      String responseBody = response.body;

      // use dart:convert to decode JSON
      dynamic decodedJson = json.decode(responseBody);

      List<NewsItem> resList = (decodedJson['news'] as List).map((item) {
        return UpgradingNewsItem.getFromJson(item);
      }).toList();

      return resList;
    } else {
      print("ERROR in getting post: status code: " +
          response.statusCode.toString());
      return [];
    }
  }
}
