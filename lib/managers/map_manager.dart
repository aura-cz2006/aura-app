import 'dart:collection';

import 'package:flutter/material.dart';

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
      {"name": "Marina Bay Sands", "lat": 103.8610, "lng": 1.284}
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
}
