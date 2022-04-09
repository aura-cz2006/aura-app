// import 'package:aura/managers/map_manager.dart';
// import 'package:aura/models/point.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// MarkerLayerOptions amenitiesMarkerLayer ( MapManager mapManager ) {
//
//   List<Marker> _amenitiesMarkers =
//   mapManager.amenitiesData.entries
//       .where((element) =>
//       mapManager.selectedCategories.contains(element.key))
//       .map((element) => element.value)
//       .expand((i) => i)
//       .map((amenity) => Point(LatLng(amenity['lat'], amenity['lng']),
//       Icons.pin_drop, Colors.redAccent))
//       .map((point) => Marker(
//     point: point.coords,
//     width: 60,
//     height: 60,
//     builder: (context) => Icon(
//       point.icon,
//       size: 60,
//       color: point.color,
//     ),
//   ))
//       .toList();
//
//   return MarkerLayerOptions(
//     markers: _amenitiesMarkers,
//     rotate: true,
//   );
// }