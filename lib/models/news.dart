import 'dart:core';
import 'package:aura/models/geolocation.dart';

class NewsItem {
  DateTime? dateTime;
  Geolocation? location;

  // constructor
  NewsItem(
    this.dateTime,
    this.location,
  );

  @override
  String toString() {
    return 'News Item: {DateTime: ${dateTime ?? ""}, Location: ${location ?? ""}}';
  }
}
