import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

abstract class NewsItem {
  String id;
  DateTime dateTime;
  String location;

  // constructor
  NewsItem(this.id, this.dateTime, this.location);

  static IconData getIcon() {
    return Icons.rsvp;
  }

  String getNewsTitle();
  String getNewsDetails();
}

class DengueNewsItem extends NewsItem {
  int numCases;

  DengueNewsItem(String id, DateTime dateTime, String location, this.numCases)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.bug_report;
  }

  @override
  String getNewsTitle() {
    return "New dengue cluster detected";
  }

  @override
  String getNewsDetails() {
    return "Location: $location \nCases: $numCases";
  }

  factory DengueNewsItem.getFromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.parse(json['date']);
    return DengueNewsItem(json['id'], dt, json['location'], json['numCases']);
  }
}

class EventNewsItem extends NewsItem {
  // todo consider start and end date
  String eventTitle;
  String fee;
  String websiteURL;

  EventNewsItem(String id, DateTime dateTime, String location, this.eventTitle,
      this.fee, this.websiteURL)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.event;
  }

  @override
  String getNewsTitle() {
    return "New event \"$eventTitle\"";
  }
  @override
  String getNewsDetails() {
    return "Location: $location \nFee: $fee";
  }

  factory EventNewsItem.getFromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.parse(json['date']);
    // LatLng location = LatLng(json['location']['lat'], json['location']['lng']);
    return EventNewsItem(json['id'], dt, json['location'], json['eventTitle'],
        json['fee'], json['url']);
  }
}

class MarketNewsItem extends NewsItem {
  String marketName;
  DateTime reopeningDate;

  // List<LatLng> alternativeMarkets = []; // todo if have time

  MarketNewsItem(String id, DateTime dateTime, String location, this.marketName,
      this.reopeningDate)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.shopping_basket;
  }

  @override
  String getNewsTitle() {
    return "$marketName will be temporarily closed";
  }
  @override
  String getNewsDetails() {
    return "Location: $location \nReopening Date: ${DateFormat('yyyy-MM-dd').format(reopeningDate)}";
  }

  factory MarketNewsItem.getFromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.parse(json['date']);
    // LatLng location = LatLng(json['location']['lat'], json['location']['lng']);
    DateTime reopening_dt = DateTime.parse(json['reopeningDate']);
    return MarketNewsItem(
        json['id'], dt, json['location'], json['marketName'], reopening_dt);
  }
}

class UpgradingNewsItem extends NewsItem {
  String desc;
  DateTime expectedEnd;

  UpgradingNewsItem(String id, DateTime dateTime, String location, this.desc,
      this.expectedEnd)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.construction;
  }

  @override
  String getNewsTitle() {
    return "Upgrading works at $location";
  }
  @override
  String getNewsDetails() {
    return "$desc \nExpected Completion: ${DateFormat('yyyy-MM-dd').format(expectedEnd)}";
  }

  factory UpgradingNewsItem.getFromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.parse(json['date']);
    // LatLng location = LatLng(json['location']['lat'], json['location']['lng']);
    DateTime end_dt = DateTime.parse(json['endDate']);
    return UpgradingNewsItem(
        json['id'], dt, json['location'], json['desc'], end_dt);
  }
}
