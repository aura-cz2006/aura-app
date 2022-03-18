import 'package:aura/managers/map_manager.dart';
import 'package:aura/view/map/amenitieschip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:aura/view/map/meetups_layer.dart';
import 'package:aura/view/map/bus_layer.dart';

class Point {
  LatLng coords = LatLng(0, 0);
  IconData? icon;
  Color? color;

  Point(this.coords, this.icon, this.color);
}

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<MapManager>(builder: (context, mapManager, child) {
      List<Point> _pointerList = [];
      // mapManager.amenities.entries
      //     .where(
      //         // (element) => element.key == "healthcare" || element.key == "F&B")
      //         (element) => mapManager.selectedCategories.contains(element.key))
      //     .toList()
      //     .map((element) => element.value)
      //     .expand((i) => i)
      //     .map((amenity) => Point(LatLng(amenity['lat'], amenity['lng']),
      //         Icons.pin_drop, Colors.redAccent))
      //     .toList();

      // print(mapManager.amenities);
      // print(mapManager.amenities.entries);
      // print(mapManager.amenities.entries.where(
      //     (element) => element.key == "healthcare" || element.key == "F&B"));
      // print(mapManager.amenities.entries
      //     .where(
      //         (element) => element.key == "healthcare" || element.key == "F&B")
      //     .toList());
      // print(mapManager.amenities.entries
      //     .where(
      //         (element) => element.key == "healthcare" || element.key == "F&B")
      //     .toList()
      //     .map((element) => element.value));

      List<Marker> _markerList = _pointerList
          .map((point) => Marker(
                point: point.coords,
                width: 60,
                height: 60,
                builder: (context) => Icon(
                  point.icon,
                  size: 60,
                  color: point.color,
                ),
              ))
          .toList();

      return mapUI(_pointerList, _markerList);
    }));
  }

  Widget mapUI(List<Point> _pointerList, List<Marker> _markerList) {
    return Stack(
      children: [

        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(1.3521, 103.8198),
            // singapore
            bounds: LatLngBounds.fromPoints(
                _pointerList.map((point) => point.coords).toList()),
            zoom: 5,
            minZoom: 0,
            maxZoom: 18,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return const Text("© OpenStreetMap contributors");
                }),
            MarkerLayerOptions(
              markers: _markerList,
              rotate: true,
            ),
          ],
        ),

        rowChips(),
        busButton(),

      ],
    );
  }
}
