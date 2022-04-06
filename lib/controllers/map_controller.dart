import 'package:aura/api_handler/map_api.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
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

  static String getTaxiDataURL() { return "https://api.data.gov.sg/v1/transport/taxi-availability";}
  static String getDengueDataURL() { return "https://geo.data.gov.sg/dengue-cluster/2021/10/07/geojson/dengue-cluster.geojson";}
  static Map<String, dynamic> getMeetupsData(BuildContext context) { // todo idk if this is right
    return Provider.of<Meetup_Manager>(context, listen: false).getMeetupsGeojson();
  }
  static Map<String, dynamic> getAmenitiesData(BuildContext context) {
    return Provider.of<MapManager>(context, listen: false).getAmenitiesGeojson();
  }
  static String getAmenityCategoryIcon(String category, BuildContext context) {
    return Provider.of<MapManager>(context, listen: false).categoryIcons[category] ?? "marker-15";
  }

}