import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/view/tabs/map/layers/amenities/amenities_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

class MapboxTab extends StatefulWidget {
  const MapboxTab({Key? key}) : super(key: key);

  @override
  State<MapboxTab> createState() => _MapboxTabState();
}

class _MapboxTabState extends State<MapboxTab> {
  late MapboxMapController controller;

  // handle taps
  void _onFillTapped(Fill fill) {
    _showSnackBar('fill', fill.id);
  }

  void _onLineTapped(Line line) {
    _showSnackBar('line', line.id);
  }

  void _onCircleTapped(Circle circle) {
    _showSnackBar('circle', circle.id);
  }

  void _onSymbolTapped(Symbol symbol) {
    _showSnackBar('symbol', symbol.id);
  }

  _showSnackBar(String type, String id) {
    final snackBar = SnackBar(
        content: Text('Tapped $type $id',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    controller.onFillTapped.remove(_onFillTapped);
    controller.onCircleTapped.remove(_onCircleTapped);
    controller.onLineTapped.remove(_onLineTapped);
    controller.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MapManager, Meetup_Manager>(
        builder: (context, mapMgr, meetupMgr, child) {
      void _onMapCreated(MapboxMapController mbController) {
        controller = mbController;
        controller.onFillTapped.add(_onFillTapped);
        controller.onCircleTapped.add(_onCircleTapped);
        controller.onLineTapped.add(_onLineTapped);
        controller.onSymbolTapped.add(_onSymbolTapped);
      }

      // initialise map layers
      void showDengueClusters() async {
        await controller.addSource(
            "dengue_clusters",
            GeojsonSourceProperties(
              attribution: "Dengue clusters data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  mapMgr.dengueData,
            ));
        await controller.addFillLayer(
            "dengue_clusters",
            "dengue_polygon",
            const FillLayerProperties(
                fillColor: "#EF9A9A",
                // circleRadius: ,
                fillOpacity: 0.7));
        await controller.addSymbolLayer(
            "dengue_clusters",
            "dengue-count",
            const SymbolLayerProperties(
              textField: "NUM",
              // TODO get number of cases
              textColor: "#C62828",
              textOpacity: 1,
              textSize: 16,
              textAnchor: "center",
              textJustify: "center",
            ));
      }

      void showTaxis() async {
        await controller.addSource(
          "taxi_locations",
          GeojsonSourceProperties(
            attribution: "Taxi availability data from data.gov.sg",
            data: // URL to a GeoJSON file, or inline GeoJSON
                mapMgr.taxiData,
          ),
        );
        // await controller.addCircleLayer( // blue dots
        //     "taxi_locations",
        //     "taxi_icons",
        //     const CircleLayerProperties(
        //       circleColor: "#2979FF",
        //       circleOpacity: 1,
        //       circleRadius: 5,
        //     ));
        await controller.addLayer(
            "taxi_locations",
            "taxi_icons",
            const SymbolLayerProperties(
              iconColor: "#2979FF", // colour broken
              iconOpacity: 1,
              iconImage: "car-15",
              iconSize: 2,
            ));
      }

      void showMeetups() async {
        // todo allow tapping
        // todo move this part creating the json to controller/manager
        Map<String, dynamic> meetupData = {
          "type": "FeatureCollection",
          "features": meetupMgr
              .getMeetupsSortedByTimeOfMeetUp()
              .map((m) => {
                    "type": "Feature",
                    "geometry": {
                      "type": "Point",
                      "coordinates": [m.location.longitude, m.location.latitude]
                    }
                  })
              .toList()
        };
        await controller.addSource(
          "meetup_locations",
          GeojsonSourceProperties(
            data: // URL to a GeoJSON file, or inline GeoJSON
                meetupData,
          ),
        );
        await controller.addSymbolLayer(
            "meetup_locations",
            "meetup_icons",
            const SymbolLayerProperties(
              iconColor: "#7C4DFF", // colour broken
              iconOpacity: 1,
              iconImage: "restaurant-pizza-15", // no ppl icon
              iconSize: 2,
            ));
      }

      void showAmenities() async {
        // todo move this part creating the json to controller/manager
        Map<String, dynamic> amenitiesData = {};
        for (String category in ['Healthcare', 'F&B']) {
          //mapMgr.selectedCategories) {
          amenitiesData = {
            "type": "FeatureCollection",
            "features": mapMgr.amenities[category]!
                .map((a) => {
                      "type": "Feature",
                      "geometry": {
                        "type": "Point",
                        "coordinates": [a['lng'], a['lat']]
                      }
                    })
                .toList()
          };
          await controller.addSource(
            "amenities_${category}_locations",
            GeojsonSourceProperties(
              data: // URL to a GeoJSON file, or inline GeoJSON
                  amenitiesData,
            ),
          );
          await controller.addSymbolLayer(
              "amenities_${category}_locations",
              "amenities_${category}_icons",
              SymbolLayerProperties(
                // iconColor: "#7C4DFF", // colour broken
                iconOpacity: 1,
                iconImage: mapMgr.categoryIcons[category], // no ppl icon
                iconSize: 2,
              ));
        }
      }

      // add map layers after style is loaded
      void _onStyleLoaded() async {
        // todo add conditional logic and check for reload
        showDengueClusters();
        showTaxis();
        showMeetups();
        showAmenities();
      }

      return Scaffold(
          body: Stack(children: [
        MapboxMap(
            accessToken:
                "pk.eyJ1IjoicmVhbGR5bGxvbiIsImEiOiJja3AyczZ0aHAwMDYyMndwNmg5Yng1em14In0.zEZQ4arU9f09eFsRTUYgSg",
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
            annotationOrder: const [
              AnnotationType.fill,
              AnnotationType.line,
              AnnotationType.circle,
              AnnotationType.symbol,
            ],
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: const CameraPosition(
              zoom: 14.0,
              target: LatLng(1.353944, 103.685979),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const AmenitiesFilterChips(),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 8),
              child: ElevatedButton(
                onPressed: () {
                  mapMgr.setSelectedCategory('taxi');
                },
                child: const Icon(Icons.car_repair, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.selectedCategories.contains('taxi')
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
                  mapMgr.setSelectedCategory('meetups');
                },
                child: const Icon(Icons.people, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.selectedCategories.contains('meetups')
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
                  mapMgr.setSelectedCategory('dengue');
                },
                child: const Icon(Icons.bug_report, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.selectedCategories.contains('dengue')
                      ? Colors.green
                      : Colors.white,
                  // <-- Button color
                  // onPrimary: Colors.red, // <-- Splash color
                ),
              ),
            ),
          ],
        )
      ]));
    });
  }
}
