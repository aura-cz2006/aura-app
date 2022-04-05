import 'package:aura/managers/map_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// points: cluster['geometry']['coordinates'][0][0].map((coords) {
//   print(coords);
//   return LatLng(0,0);
//   // return LatLng(coords[0], coords[1]);
// }))

List<Polygon> denguePolygons(MapManager mapManager) {
  // mapManager.dengueData.forEach((cluster) {
  //   print(cluster['geometry']['coordinates'][0][0]);
  // });

  // dynamic clustertemp = mapManager.dengueData
  //     .map((cluster) => cluster['geometry']['coordinates'][0][0])
  //     .toList();
  //
  // clustertemp.forEach((element) {
  //   print(element);
  // });

  // List<Polygon> _polygons = !mapManager.selectedLayers.contains('dengue')
  //     ? []
  //     : mapManager.dengueData
  //         // .map((cluster) => cluster['geometry']['coordinates'][0][0])
  //         .map((element) => Polygon(points: [LatLng(0, 0)]))
  //         .toList();
  //
  // return _polygons;
  return [];
}
