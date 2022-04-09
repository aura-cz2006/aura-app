import 'dart:async';
import 'dart:math';
import 'package:aura/controllers/map_controller.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:aura/view/map/amenities_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

// void main() => runApp(MultiProvider(providers: [
//       ChangeNotifierProvider(create: (context) => MapManager()),
//       ChangeNotifierProvider(create: (context) => Meetup_Manager()),
//     ], child: const MapboxTab()));

class MapboxTab extends StatefulWidget {
  const MapboxTab({Key? key}) : super(key: key);

  @override
  State<MapboxTab> createState() => _MapboxTabState();
}

class _MapboxTabState extends State<MapboxTab> {
  late MapboxMapController controller;

  @override
  void initState() {
    super.initState();
  }

  // handle taps
  void _onFeatureTapped(
      dynamic featureId, Point<double> point, LatLng coordinates) {
    _showSnackBar('feature', coordinates.toString());
  }

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
        controller.onFeatureTapped.add(_onFeatureTapped);
        controller.onFillTapped.add(_onFillTapped);
        controller.onCircleTapped.add(_onCircleTapped);
        controller.onLineTapped.add(_onLineTapped);
        controller.onSymbolTapped.add(_onSymbolTapped);
      }

      // initialise map layers
      void initDengueLayer() async {
        await controller.addSource(
            "dengue_clusters",
            GeojsonSourceProperties(
              attribution: "Dengue clusters data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  MapController.getDengueDataURL(),
              promoteId: 'Name', // TODO TESTING
            ));
        await controller.addFillLayer("dengue_clusters", "dengue_polygon",
            const FillLayerProperties(fillColor: "#EF9A9A", fillOpacity: 0.7));
        await controller.addSymbolLayer(
            "dengue_clusters",
            "dengue_count",
            const SymbolLayerProperties(
              textField: "4",
              // TODO get number of cases
              textColor: "#C62828",
              textOpacity: 1,
              textSize: 16,
              textAnchor: "center",
              textJustify: "center",
            ));
      }

      void initTaxisLayer() async {
        // MapController.fetchTaxiData(context); // todo doesnt work
        await controller.addSource(
          "taxi_locations",
          GeojsonSourceProperties(
            attribution: "Taxi availability data from data.gov.sg",
            data: // URL to a GeoJSON file, or inline GeoJSON
                MapController
                    .getTaxiDataURL(), //todo use mapMgr.taxiData, but it gives {}?
          ),
        );
        await controller.addLayer(
            "taxi_locations",
            "taxi_icons",
            const SymbolLayerProperties(
              iconOpacity: 1,
              iconImage: "car-15",
              iconSize: 2,
            ));
      }

      void initBusStopLayer() async {
        MapController.fetchBusStopData(context); // todo doesnt work
        await controller.addSource(
          "bus_stop_locations",
          GeojsonSourceProperties(
              attribution: "Bus stop data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  mapMgr.getBusStopDataGeojson() // todo, but it gives {}?
              ),
        );
        await controller.addLayer(
            "bus_stop_locations",
            "bus_icons",
            const SymbolLayerProperties(
              iconOpacity: 1,
              iconImage: "bus-15",
              iconSize: 2,
            ));
      }

      void initMeetupsLayer() async {
        // todo allow tapping
        await controller.addSource(
          "meetup_locations",
          GeojsonSourceProperties(
            data: // URL to a GeoJSON file, or inline GeoJSON
                MapController.getMeetupsData(context),
          ),
        );
        await controller.addSymbolLayer(
            "meetup_locations",
            "meetup_icons",
            const SymbolLayerProperties(
              iconOpacity: 1,
              iconImage: "heart-15", // todo no ppl icon
              iconSize: 2,
            ));
      }

      void initAmenitiesLayer() async {
        Map<AmenityCategory, dynamic> amenitiesData =
            MapController.getAmenitiesGeojson(context);
        // amenitiesData.forEach((category, data)
        for (AmenityCategory category in mapMgr.categories) {
          String queryString = CategoryConvertor.getQueryString(category)!;
          await controller.addSource(
            "amenities_${queryString}_locations",
            GeojsonSourceProperties(
              data: amenitiesData[category],
            ),
          );
          // await controller.addSymbolLayer(
          //     "amenities_${queryString}_locations",
          //     "amenities_${queryString}_icons",
          //     SymbolLayerProperties(
          //       iconOpacity: 1,
          //       iconImage: CategoryConvertor.getIcon(category),
          //       iconSize: 2,
          //     ));
        }
      }

      void updateTaxiLayer() async {
        await controller.removeLayer("taxi_icons");
        if (mapMgr.isLayerSelected('taxis')) {
          await controller.addLayer(
              "taxi_locations",
              "taxi_icons",
              const SymbolLayerProperties(
                iconOpacity: 1,
                iconImage: "car-15",
                iconSize: 2,
              ));
        }
      }

      void updateDengueLayer() async {
        await controller.removeLayer("dengue_polygon");
        await controller.removeLayer("dengue_count");
        if (mapMgr.isLayerSelected('dengue')) {
          await controller.addFillLayer(
              "dengue_clusters",
              "dengue_polygon",
              const FillLayerProperties(
                fillColor: "#EF9A9A",
                fillOpacity: 0.7,
              ));
          await controller.addSymbolLayer(
              "dengue_clusters",
              "dengue_count",
              const SymbolLayerProperties(
                textField: "4",
                // TODO get number of cases
                textColor: "#C62828",
                textOpacity: 1,
                textSize: 16,
                textAnchor: "center",
                textJustify: "center",
              ));
        }
      }

      void updateMeetupsLayer() async {
        await controller.removeLayer("meetup_icons");
        if (mapMgr.isLayerSelected('meetups')) {
          await controller.addSymbolLayer(
              "meetup_locations",
              "meetup_icons",
              const SymbolLayerProperties(
                iconOpacity: 1,
                iconImage: "restaurant-pizza-15", // todo no ppl icon
                iconSize: 2,
              ));
        }
      }

      // add map layers after style is loaded
      void _onStyleLoaded() async {
        initDengueLayer();
        initTaxisLayer();
        initBusStopLayer();
        initMeetupsLayer();
        initAmenitiesLayer();

        // refresh data periodically
        Timer.periodic(const Duration(seconds: 30), (t) {
          updateTaxiLayer();
          updateDengueLayer();
          updateMeetupsLayer();
          // updateAllAmenitiesLayers(); // todo no update bc static
        });
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
              AnnotationType.symbol,
              AnnotationType.line,
              AnnotationType.circle,
            ],
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                northeast: const LatLng(1.493, 104.131),
                southwest: const LatLng(1.129, 103.557))),
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: const CameraPosition(
              zoom: 14.0,
              target: LatLng(1.353944, 103.685979),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: mapMgr.categories
                      .map((category) => AmenityChip(
                            category: category,
                            onSelected: (bool selected) async {
                              mapMgr.toggleSelectedCategory(category);
                              String queryString =
                                  CategoryConvertor.getQueryString(category)!;
                              if (selected) {
                                await controller.addSymbolLayer(
                                    "amenities_${queryString}_locations",
                                    "amenities_${queryString}_icons",
                                    SymbolLayerProperties(
                                      iconOpacity: 1,
                                      iconImage: CategoryConvertor.getIcon(category),
                                      iconSize: 2,
                                    ));
                              } else {
                                await controller.removeLayer(
                                    "amenities_${queryString}_icons");
                              }
                            },
                          ))
                      .toList()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 8),
              child: ElevatedButton(
                onPressed: () {
                  mapMgr.toggleLayer('taxis');
                  updateTaxiLayer();
                },
                child: Icon(Icons.car_repair,
                    color: mapMgr.isLayerSelected('taxis')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerSelected('taxis')
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
                  mapMgr.toggleLayer('meetups');
                  updateMeetupsLayer();
                },
                child: Icon(Icons.people,
                    color: mapMgr.isLayerSelected('meetups')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerSelected('meetups')
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
                  mapMgr.toggleLayer('dengue');
                  updateDengueLayer();
                },
                child: Icon(Icons.bug_report,
                    color: mapMgr.isLayerSelected('dengue')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerSelected('dengue')
                      ? Colors.green
                      : Colors.white,
                ),
              ),
            ),
          ],
        )
      ]));
    });
  }
}
