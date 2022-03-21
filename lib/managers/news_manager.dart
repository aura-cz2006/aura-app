import 'dart:collection';
import 'package:aura/util/manager.dart';

class NewsManager extends Manager {
  final List<NewsItem> _upcomingnews = [];

  final List<NewsItem> _currentnews = [];


  UnmodifiableListView<NewsItem> get currentnews =>
      UnmodifiableListView(_currentnews);

        UnmodifiableListView<NewsItem> get upcomingnews =>
      UnmodifiableListView(_upcomingnews);



  void setNews(List<NewsItem> news) {
  
  }