import 'package:aura/controllers/news_controller.dart';
import 'package:aura/controllers/thread_controller.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/view/tabs/map/layers/amenities/amenities_filter_chips.dart';
import 'package:aura/view/tabs/map/layers/dengue/dengue_markers.dart';
import 'package:aura/view/tabs/map/layers/meetups/meetups_markers.dart';
import 'package:aura/view/tabs/map/layers/taxi/taxi_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Point {
  LatLng coords = LatLng(0, 0);
  IconData? icon;
  Color? color;

  Point(this.coords, this.icon, this.color);
}

final List<Point> _pointList = [
  Point(LatLng(1.3483, 103.6831), Icons.pin_drop, Colors.redAccent),
  // ntu
  Point(LatLng(1.3644, 103.9915), Icons.pin_drop, Colors.blueAccent),
  // changi airport
];

List<Marker> _testMarkers = _pointList
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

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    // initialise markers at each point in latLngList
    ThreadController.fetchThreads(context);
    NewsController.fetchNews(context); // get initial

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<MapManager>(builder: (context, mapManager, child) {
      List<Marker> _amenitiesMarkers = mapManager.amenities.entries
          .where(
              (element) => mapManager.selectedCategories.contains(element.key))
          .toList()
          .map((element) => element.value)
          .expand((i) => i)
          .map((amenity) => Point(LatLng(amenity['lat'], amenity['lng']),
              Icons.pin_drop, Colors.redAccent))
          .toList()
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

      return Consumer2<MapManager, Meetup_Manager>(
          builder: (context, mapManager, meetupManager, child) {
            print(mapManager.selectedLayers);
        print("taxi present ${mapManager.isLayerEnabled('taxi')}");

        return Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(1.3521, 103.8198),
              // singapore
              // bounds: LatLngBounds.fromPoints(_pointList.map((point) => point.coords).toList()),
              bounds: LatLngBounds.fromPoints(
                  [LatLng(1.3483, 103.6231), LatLng(1.3644, 104.0415)]),
              // singapore west and east
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
              // MarkerLayerOptions(
              //   markers: _testMarkers,
              //   rotate: true,
              // ),
              MarkerLayerOptions(
                markers: _amenitiesMarkers,
                rotate: true,
              ),
              MarkerLayerOptions(
                markers: taxiMarkers(mapManager.taxis,
                    mapManager.selectedLayers.contains('taxi')),
                rotate: true,
              ),
              MarkerLayerOptions(
                markers: meetupsMarkers(mapManager, meetupManager),
                rotate: true,
              ),
              PolygonLayerOptions(polygons: denguePolygons(mapManager))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const AmenitiesFilterChips(),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    mapManager.setSelectedCategory('taxi');
                  },
                  child: const Icon(Icons.car_repair, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    primary: mapManager.selectedCategories.contains('taxi')
                        ? Colors.blue
                        : Colors.white,
                    // <-- Button color
                    // onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    mapManager.setSelectedCategory('meetups');
                  },
                  child: const Icon(Icons.people, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    primary: mapManager.selectedCategories.contains('meetups')
                        ? Colors.deepPurple
                        : Colors.white,
                    // <-- Button color
                    // onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    mapManager.setSelectedCategory('dengue');
                  },
                  child: const Icon(Icons.bug_report, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    primary: mapManager.selectedCategories.contains('dengue')
                        ? Colors.green
                        : Colors.white,
                    // <-- Button color
                    // onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ),
            ],
          )
        ]);
      });
    }));
  }
}
