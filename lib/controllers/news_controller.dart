import 'package:aura/apis/news_api.dart';
import 'package:aura/managers/news_manager.dart';
import 'package:aura/models/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsController {
  static void fetchNews(BuildContext context) async {

    // call api (convert to dart there) and receive api data
    List<NewsItem> fetchedNewsItems = await NewsApi.fetchNews();

    // call provider
    Provider.of<News_Manager>(context, listen: false).setNews(
        fetchedNewsItems
    );
  }

}