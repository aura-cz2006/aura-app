enum AmenityCategory {
  HawkerCenters,
  Supermarkets,
  Pharmacies,
  CommunityCenters,
  Police,
  Parks,
  Hotels,
  FireStations,
  Museums,
  BikeRacks,
  Bloodbanks
}

extension CategoryConvertor on AmenityCategory {
  static const READABLE = 0;
  static const QUERYSTRING = 1;
  static const ICON = 2;
  static Map<AmenityCategory, List<String>> categoryMap = {
    AmenityCategory.HawkerCenters: ["Hawker Centers", "hawkercentre", "restaurant-15"],
    AmenityCategory.Supermarkets: ["Supermarkets", "supermarkets", "grocery-15"],
    AmenityCategory.Pharmacies: ["Pharmacies", "registered_pharmacy", "hospital-15"],
    AmenityCategory.CommunityCenters: ["Community Centers", "communityclubs", "town-hall-15"],
    AmenityCategory.Police: ["Police", "spf_establishments", "police-15"],
    AmenityCategory.Parks: ["Parks", "nationalparks", "police-15"],
    AmenityCategory.Hotels: ["Hotels", "hotels", "lodging-15"],
    AmenityCategory.FireStations: ["Fire Stations", "firestation", "fire-station-15"],
    AmenityCategory.Museums: ["Museums", "museum", "museum-15"],
    AmenityCategory.BikeRacks: ["Bicycle Racks", "bicyclerack", "bicycle-15"],
    AmenityCategory.Bloodbanks: ["Blood Banks", "blood_bank", "blood-bank-15"]
  };

  static String? getReadable(AmenityCategory cat) {
    if (categoryMap.containsKey(cat)) {
      return categoryMap[cat]![READABLE];
    } else {
      return null;
    }
  }

  static String? getQueryString(AmenityCategory cat) {
    if (categoryMap.containsKey(cat)) {
      return categoryMap[cat]![QUERYSTRING];
    } else {
      return null;
    }
  }

  static String? getIcon(AmenityCategory cat) {
    if (categoryMap.containsKey(cat)) {
      return categoryMap[cat]![ICON];
    } else {
      return null;
    }
  }
}