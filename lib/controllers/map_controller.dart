import 'dart:collection';

import 'package:aura/apis/map_api.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapController {
  static void fetchTaxiData(BuildContext context) async {
    Map<String, dynamic> fetchedTaxiData = await MapApi.fetchTaxiData();

    // call provider
    Provider.of<MapManager>(context, listen: false).setTaxiData(
        fetchedTaxiData
    );
  }
  static void fetchSelectedAmenities(BuildContext context) async {
    List<AmenityCategory> selectedCat = List.from(Provider.of<MapManager>(context, listen: false).selectedCategories);
    for (AmenityCategory category in selectedCat) { // todo resolve concurrent modification during iteration
      print("=========== FETCHING FOR ${CategoryConvertor.getQueryString(category)}");
      List<dynamic> fetchedAmenitiesData = await MapApi.fetchAmenitiesData(category);
      Provider.of<MapManager>(context, listen: false).updateAmenitiesData(category,
          fetchedAmenitiesData
      );
    }
  }

  static String getTaxiDataURL() { return "https://api.data.gov.sg/v1/transport/taxi-availability";}
  static String getDengueDataURL() { return "https://geo.data.gov.sg/dengue-cluster/2021/10/07/geojson/dengue-cluster.geojson";}
  static Map<String, dynamic> getMeetupsData(BuildContext context) {
    //todo call meetup controller to fetch (need to merge w other branch first)
    return Provider.of<Meetup_Manager>(context, listen: false).getMeetupsGeojson();
  }
  static Map<AmenityCategory, dynamic> getAmenitiesData(BuildContext context) {
    fetchSelectedAmenities(context);
    return Provider.of<MapManager>(context, listen: false).getAmenitiesGeojson();
  }
  static String getAmenityCategoryIcon(AmenityCategory category) {
    return CategoryConvertor.getIcon(category) ?? "marker-15";
  }

  static void fetchBusStopData(BuildContext context) async {
    List<Map<String, dynamic>> fetchedBusStopData = await MapApi.fetchBusStopData();

    // call provider
    Provider.of<MapManager>(context, listen: false).setBusStopData(
        fetchedBusStopData
    );
  }

}