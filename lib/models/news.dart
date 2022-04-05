import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

abstract class NewsItem {
  DateTime dateTime;
  LatLng location;

  // constructor
  NewsItem(this.dateTime, this.location);

  static IconData getIcon() {
    return Icons.newspaper;
  }
  String getText();
  String getPopupText();
  String getTitle();
}

class DengueNewsItem extends NewsItem {
  int numCases;

  DengueNewsItem(DateTime dateTime, LatLng location, this.numCases)
      : super(dateTime, location);

  static IconData getIcon() {
    return Icons.bug_report;
  }
  @override
  String getText() {
    return "New dengue cluster detected at $location ($numCases cases).";
  }
  String getPopupText() {
    return "Cases: $numCases \n"
        "Location: $location \n"
        "Date: $dateTime";
  }
  String getTitle() {
    return "New Dengue Cluster";
  }
}

class EventNewsItem extends NewsItem { // todo consider start and end date
  String eventTitle;
  double fee = 0;
  String websiteURL;

  EventNewsItem(DateTime dateTime, LatLng location, this.eventTitle, this.fee, this.websiteURL)
      : super(dateTime, location);

  static IconData getIcon() {
    return Icons.event;
  }
  @override
  String getText() {
    return "New event \"$eventTitle\" hosted at $location (fee: \$$fee).";
  }

  @override
  String getPopupText() {
    return "Event title: \"$eventTitle\" \n"
        "Location: $location \n"
        "fee: \$$fee";
  }
  String getTitle() {
    return "New Event";
  }
}

class MarketNewsItem extends NewsItem {
  String marketName;
  DateTime reopeningDate;
  List<LatLng> alternativeMarkets = [];

  MarketNewsItem(
      DateTime dateTime, LatLng location, this.marketName, this.reopeningDate)
      : super(dateTime, location);

  static IconData getIcon() {
    return Icons.shopping_basket;
  }
  @override
  String getText() {
    return "$marketName will be closed until ${DateFormat('yyyy-MM-dd kk:mm').format(reopeningDate)}.";
  }

  String getPopupText() {
    return "$marketName will be closed until ${DateFormat('yyyy-MM-dd kk:mm').format(reopeningDate)}.";
  }

  String getTitle() {
    return "Market Closure";
  }
}

class UpgradingNewsItem extends NewsItem {
  String desc;
  DateTime expectedEnd;

  UpgradingNewsItem(
      DateTime dateTime, LatLng location, this.desc, this.expectedEnd)
      : super(dateTime, location);

  static IconData getIcon() {
    return Icons.construction;
  }
  @override
  String getText() {
    return "Upgrading works at $location: $desc (expected completion: ${DateFormat('yyyy-MM-dd kk:mm').format(expectedEnd)} ).";
  }
  String getPopupText() {
    return "Location: $location \n"
        "Description: $desc \n"
        "Expected Completion: ${DateFormat('yyyy-MM-dd kk:mm').format(expectedEnd)}";
  }
  String getTitle() {
    return "Upgrading Works";
  }
}
