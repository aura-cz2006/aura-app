import 'package:aura/apis/map_api.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapController {
  static void fetchAmenitiesData(BuildContext context) async {
    for (AmenityCategory category
        in Provider.of<MapManager>(context, listen: false).categories) {
      List<dynamic> fetchedAmenitiesData =
          await MapApi.fetchAmenitiesData(category);
      Map<String, dynamic> geojson = {
        "type": "FeatureCollection",
        "features": fetchedAmenitiesData
            .map((a) => {
                  "type": "Feature",
                  "geometry": {
                    "type": "Point",
                    "coordinates": [a['lng'], a['lat']]
                  }
                })
            .toList()
      };
      Provider.of<MapManager>(context, listen: false)
          .updateAmenitiesGeojsonData(category, geojson);
    }
  }

  static String getTaxiDataURL() {
    return "https://api.data.gov.sg/v1/transport/taxi-availability";
  }

  static String getDengueDataURL() {
    return "https://geo.data.gov.sg/dengue-cluster/2021/10/07/geojson/dengue-cluster.geojson";
  }

  static Map<String, dynamic> getMeetupsData(BuildContext context) {
//todo call meetup controller to fetch (need to merge w other branch first)
    return Provider.of<Meetup_Manager>(context, listen: false)
        .getMeetupsGeojson();
  }

  static Map<AmenityCategory, dynamic> getAmenitiesGeojson(
      BuildContext context) {
    fetchAmenitiesData(context);
    return Provider.of<MapManager>(context, listen: false).amenitiesGeojsonData;
  }

  static void fetchBusStopData(BuildContext context) async {
    List<Map<String, dynamic>> fetchedBusStopData =
        await MapApi.fetchBusStopData();
    Provider.of<MapManager>(context, listen: false)
        .setBusStopData(fetchedBusStopData);
  }
}
