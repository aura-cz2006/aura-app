import 'package:aura/models/taxi.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

Map<String, dynamic> MapCategory = {};

class MapManager extends ChangeNotifier {
  final List<String> categories = [
    "ATM",
    "F&B",
    "Healthcare",
    "Community Center",
    "Police",
    "Park",
    "School",
    "Supermarket",
    "Hotels"
  ];

  final Map<dynamic, List<Map<String, dynamic>>> amenities = {
    "Healthcare": [
      {"name": "Singapore General Hospital", "lat": 1.2804, "lng": 103.8348}
    ],
    "F&B": [
      {"name": "Marina Bay Sands", "lat": 1.284, "lng": 103.8610}
    ]
  };

  List<String> selectedCategories = [];

  // UnmodifiableListView<String> get categories =>
  //     UnmodifiableListView(_categories);
  //
  // UnmodifiableListView<String> get selectedCategories =>
  //     UnmodifiableListView(_selectedCategories);

  // todo add updater functions
  void setSelectedCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.removeWhere((element) => element == category);
    } else {
      selectedCategories.add(category);
    }

    print(selectedCategories);

    notifyListeners();
  }

  // * layers
  List<String> selectedLayers = [];

  void toggleLayer(String layerName) {
    if (selectedLayers.contains(layerName)) {
      selectedLayers.removeWhere((element) => element == layerName);
    } else {
      selectedLayers.add(layerName);
    }
  }

  // * taxis

  List<Taxi> taxis = [
    Taxi("1", LatLng(1.341285, 103.683926), 30, "ComfortDelgro",
        Colors.blueAccent)
  ];

}
