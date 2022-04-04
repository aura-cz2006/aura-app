import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

abstract class NewsItem {
  String id;
  DateTime dateTime;
  LatLng location; //todo replace latlng

  // constructor
  NewsItem(this.id, this.dateTime, this.location);

  static IconData getIcon() {
    return Icons.newspaper;
  }

  String getText();
}

class DengueNewsItem extends NewsItem {
  int numCases;

  DengueNewsItem(String id, DateTime dateTime, LatLng location, this.numCases)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.bug_report;
  }

  @override
  String getText() {
    return "New dengue cluster detected at $location ($numCases cases).";
  }

  factory DengueNewsItem.getFromJson(Map<String, dynamic> json) {
    // TODO test
    DateTime dt = DateTime.parse(json['date']);
    LatLng location = LatLng(0, 0); // TODO LatLng(json['location'][0], json['location'][1]);
    return DengueNewsItem(json['id'], dt, location, json['numCases']);
  }
}

class EventNewsItem extends NewsItem {
  // todo consider start and end date
  String eventTitle;
  String fee;
  String websiteURL;

  EventNewsItem(String id, DateTime dateTime, LatLng location, this.eventTitle,
      this.fee, this.websiteURL)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.event;
  }

  @override
  String getText() {
    return "New event \"$eventTitle\" hosted at $location (fee: $fee).";
  }

  factory EventNewsItem.getFromJson(Map<String, dynamic> json) {
    // TODO test
    DateTime dt = DateTime.parse(json['date']);
    LatLng location = LatLng(0,0); // TODO LatLng(json['location'][0], json['location'][1]);
    return EventNewsItem(json['id'], dt, location, json['eventTitle'],
        json['fee'], json['url']);
  }
}

class MarketNewsItem extends NewsItem {
  String marketName;
  DateTime reopeningDate;

  // List<LatLng> alternativeMarkets = []; // todo if have time

  MarketNewsItem(String id, DateTime dateTime, LatLng location, this.marketName,
      this.reopeningDate)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.shopping_basket;
  }

  @override
  String getText() {
    return "$marketName will be closed until ${DateFormat('yyyy-MM-dd kk:mm').format(reopeningDate)}.";
  }

  factory MarketNewsItem.getFromJson(Map<String, dynamic> json) {
    // TODO test
    DateTime dt = DateTime.parse(json['date']);
    LatLng location = LatLng(0,0); // TODO LatLng(json['location'][0], json['location'][1]);
    DateTime reopening_dt = DateTime.parse(json['reopeningDate']);
    return MarketNewsItem(
        json['id'], dt, location, json['marketName'], reopening_dt);
  }
}

class UpgradingNewsItem extends NewsItem {
  String desc;
  DateTime expectedEnd;

  UpgradingNewsItem(String id, DateTime dateTime, LatLng location, this.desc,
      this.expectedEnd)
      : super(id, dateTime, location);

  static IconData getIcon() {
    return Icons.construction;
  }

  @override
  String getText() {
    return "Upgrading works at $location: $desc (expected completion: \$${DateFormat('yyyy-MM-dd kk:mm').format(expectedEnd)} ).";
  }

  factory UpgradingNewsItem.getFromJson(Map<String, dynamic> json) {
    //todo test
    DateTime dt = DateTime.parse(json['date']);
    LatLng location = LatLng(0,0); // TODO LatLng(json['location'][0], json['location'][1]);
    DateTime end_dt = DateTime.parse(json['endDate']);
    return UpgradingNewsItem(
        json['id'], dt, location, json['desc'], end_dt);
  }
}
