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
