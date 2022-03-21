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

class DengueNewsItem extends NewsItem {
  DengueNewsItem(DateTime dateTime, Geolocation location) : super(dateTime, location);
  int numCases = 0;

  @override
  String toString() {
    return 'Dengue News Item: {Datetime: ${dateTime ?? ""}, Location: ${location ??""}, Number of Case: ${numCases ??""}}';
  }
}

class EventNewsItem extends NewsItem {
  EventNewsItem(DateTime? dateTime, Geolocation? location) : super(dateTime, location);
  String eventTitle = "event";
  String toString() {
    return 'Event News Item: {Datetime: ${dateTime ?? ""}, Location: ${location ??""}, Event Title: ${eventTitle ?? ""}}';
  }
}

class MarketNewsItem extends NewsItem {
  MarketNewsItem(DateTime? dateTime, Geolocation? location) : super(dateTime, location);
  String marketName = "marketName";
  String toString() {
    return 'Event News Item: {Datetime: ${dateTime ?? ""}, Location: ${location ??""}, Market Name: ${marketName ?? ""}}';
  }

}

class UpgradingNewsItem extends NewsItem {
  UpgradingNewsItem(DateTime? dateTime, Geolocation? location) : super(dateTime, location);
  String desc = "Desc";

  String toString() {
    return 'Event News Item: {Datetime: ${dateTime ?? ""}, Location: ${location ??""}, Description: ${desc ?? ""}}';
  }
}

