import 'dart:collection';

import 'package:aura/models/amenity_category.dart';
import 'package:aura/util/manager.dart';

class MapManager extends Manager {
  Map<String, dynamic> _taxiData = {};

  Map<String, dynamic> dengueData = {};

  late List<AmenityCategory> categories = AmenityCategory.values.toList();

  List<AmenityCategory> selectedCategories = [];

  Map<AmenityCategory, Map<String, dynamic>> amenitiesGeojsonData = {};

  List<Map<String, dynamic>> busStopData = [];
  void setBusStopData(List<Map<String, dynamic>> newData) {
    busStopData = newData;
    notifyListeners();
  }
  Map<String, dynamic> getBusStopDataGeojson() {
    Map<String, dynamic> res = {};
      res = {
        "type": "FeatureCollection",
        "features": (busStopData)
            .map((b) => {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [b['Longitude'], b['Latitude']]
          }
        })
            .toList()
    };
    return res;
  }
  // {
  //   AmenityCategory.Pharmacies: [
  //     {"name": "Singapore General Hospital", "lat": 1.2804, "lng": 103.8348}
  //   ],
  //   AmenityCategory.HawkerCenters: [
  //     {"name": "Marina Bay Sands", "lat": 1.284, "lng": 103.8610}
  //   ]
  // };

  void updateAmenitiesGeojsonData(AmenityCategory category, Map<String, dynamic> newGeojsonData) {
    if (amenitiesGeojsonData.keys.contains(category)) {
      amenitiesGeojsonData.update(category, (value) => newGeojsonData);
    } else {
      amenitiesGeojsonData[category] = newGeojsonData;
    }
    notifyListeners();
  }

  UnmodifiableMapView<String, dynamic> get taxiData =>
          UnmodifiableMapView(_taxiData);
  // Map<AmenityCategory, Map<String, dynamic>> getAmenitiesGeojson() {
  //   Map<AmenityCategory, Map<String, dynamic>> res = {};
  //   for (AmenityCategory category in selectedCategories) {
  //     res[category] = {
  //       "type": "FeatureCollection",
  //       "features": (amenitiesData[category] ??
  //           [])
  //               .map((a) => {
  //                     "type": "Feature",
  //                     "geometry": {
  //                       "type": "Point",
  //                       "coordinates": [a['lng'], a['lat']]
  //                     }
  //                   })
  //               .toList()
  //     };
  //   }
  //   return res;
  // }

  // UnmodifiableListView<String> get categories =>
  //     UnmodifiableListView(_categories);
  //
  // UnmodifiableListView<String> get selectedCategories =>
  //     UnmodifiableListView(_selectedCategories);

  // todo add updater functions
  void toggleSelectedCategory(AmenityCategory category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.removeWhere((element) => element == category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  List<String> selectedLayers = ['taxis', 'meetups', 'dengue'];
  void toggleLayer(String layerName) {
    if (selectedLayers.contains(layerName)) {
      selectedLayers.removeWhere((element) => element == layerName);
    } else {
      selectedLayers.add(layerName);
    }
    notifyListeners();
  }

  bool isLayerSelected(String layerName) {
    return selectedLayers.contains(layerName);
  }

  bool isCategorySelected(AmenityCategory category) {
    return selectedCategories.contains(category);
  }

  void setTaxiData(Map<String, dynamic> fetchedTaxiData) {
    _taxiData = fetchedTaxiData;
    notifyListeners();
  }
}
