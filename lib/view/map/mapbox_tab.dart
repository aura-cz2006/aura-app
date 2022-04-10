import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:aura/controllers/map_controller.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:aura/view/tabs/map/layers/amenities/amenities_filter_chips.dart';
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
  late UniqueKey _mapKey;

  @override
  void initState() {
    _mapKey = UniqueKey();
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
      void initDengueClustersLayer() async {
        await controller.addSource(
            "dengue_clusters",
            GeojsonSourceProperties(
              attribution: "Dengue clusters data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  MapController.getDengueDataURL(),
              promoteId: 'Name',
            ));
        await controller.addFillLayer(
            "dengue_clusters",
            "dengue_polygon",
            FillLayerProperties(
                fillColor: "#EF9A9A",
                // circleRadius: ,
                fillOpacity: 0.7,
                visibility: "none"
                // mapMgr.isLayerEnabled('dengue')
                //     ? "visible" //
                //     : "none"
                ));
        await controller.addSymbolLayer(
            "dengue_clusters",
            "dengue_count",
            const SymbolLayerProperties(
              textField: "4",
              textColor: "#C62828",
              textOpacity: 1,
              textSize: 16,
              textAnchor: "center",
              textJustify: "center",
            ));
      }

      void initTaxisLayer() async {
        MapController.fetchTaxiData(context);
        await controller.addSource(
          "taxi_locations",
          GeojsonSourceProperties(
            attribution: "Taxi availability data from data.gov.sg",
            data: // URL to a GeoJSON file, or inline GeoJSON
                MapController
                    .getTaxiDataURL(),
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

      void initBusStopLayer() async {
        MapController.fetchBusStopData(context);
        await controller.addSource(
          "bus_stop_locations",
          GeojsonSourceProperties(
              attribution: "Bus stop data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  mapMgr.getBusStopDataGeojson()
              ),
        );
        await controller.addLayer(
            "bus_stop_locations",
            "bus_icons",
            const SymbolLayerProperties(
              iconColor: "#2979FF", // colour broken
              iconOpacity: 1,
              iconImage: "bus-15",
              iconSize: 2,
            ));
      }

      void initMeetupsLayer() async {
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
              iconColor: "#7C4DFF", // colour broken
              iconOpacity: 1,
              iconImage: "restaurant-pizza-15",
              iconSize: 2,
            ));
      }

      void initAmenitiesLayer() async {
        Map<AmenityCategory, dynamic> amenitiesData =
            MapController.getAmenitiesData(context);
        amenitiesData.forEach((category, data) async {
          await controller.addSource(
            "amenities_${CategoryConvertor.getQueryString(category)}_locations",
            GeojsonSourceProperties(
              data: data,
            ),
          );
        });
      }

      void updateLayers(String type) async {
        if (type == 'taxis' || type == 'all') {
          await controller.removeLayer("taxi_icons");
          if (mapMgr.isLayerEnabled('taxis')) {
            await controller.addLayer(
                "taxi_locations",
                "taxi_icons",
                const SymbolLayerProperties(
                  iconColor: "#2979FF", // colour broken
                  iconOpacity: 1,
                  iconImage: "car-15",
                  iconSize: 2,
                  // visibility: "none"
                ));
          }
        }
        if (type == 'dengue' || type == 'all')
          await controller.removeLayer("dengue_polygon");
        await controller.removeLayer("dengue_count");
        if (mapMgr.isLayerEnabled('dengue')) {
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
                textColor: "#C62828",
                textOpacity: 1,
                textSize: 16,
                textAnchor: "center",
                textJustify: "center",
              ));
        }
        if (type == 'meetups' || type == 'all') {
          await controller.removeLayer("meetup_icons");
          if (mapMgr.isLayerEnabled('meetups')) {
            await controller.addSymbolLayer(
                "meetup_locations",
                "meetup_icons",
                const SymbolLayerProperties(
                  iconColor: "#7C4DFF", // colour broken
                  iconOpacity: 1,
                  iconImage: "restaurant-pizza-15",
                  iconSize: 2,
                ));
          }
        }
        if (type == 'amenities' || type == 'all') {
          for (AmenityCategory category in mapMgr.amenitiesData.keys) {
            await controller.removeLayer("amenities_${CategoryConvertor.getQueryString(category)}_locations");
          }
          Map<AmenityCategory, dynamic> amenitiesData =
              MapController.getAmenitiesData(context);
          amenitiesData.forEach((category, data) async {
            await controller.addSource(
              "amenities_${CategoryConvertor.getQueryString(category)}_locations",
              GeojsonSourceProperties(
                data: data,
              ),
            );
          });
        }
      }

      // add map layers after style is loaded
      void _onStyleLoaded() async {
        initDengueClustersLayer();
        initTaxisLayer();
        initBusStopLayer();
        initMeetupsLayer();
        initAmenitiesLayer();

        Timer timer = Timer.periodic(const Duration(seconds: 30), (t) {
          // setState(() => _mapKey = UniqueKey());
          updateLayers('all');
          // controller.setGeoJsonSource(
          //     "dengue_clusters", mapMgr.isLayerEnabled('dengue') ? MapController.getDengueDataURL(context) : {});
          // controller.setGeoJsonSource(
          //     "meetup_locations", MapController.getMeetupsData(context));
        });
      }

      return Scaffold(
          body: Stack(children: [
        MapboxMap(
            key: _mapKey,
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
            AmenitiesFilterChips(
              onTap: () => updateLayers('amenities'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 8),
              child: ElevatedButton(
                onPressed: () {
                  mapMgr.toggleLayer('taxis');
                  updateLayers('taxis');
                },
                child: Icon(Icons.car_repair,
                    color: mapMgr.isLayerEnabled('taxis')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerEnabled('taxis')
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
                  updateLayers('meetups');
                },
                child: Icon(Icons.people,
                    color: mapMgr.isLayerEnabled('meetups')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerEnabled('meetups')
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
                  updateLayers('dengue');
                },
                child: Icon(Icons.bug_report,
                    color: mapMgr.isLayerEnabled('dengue')
                        ? Colors.white
                        : Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: mapMgr.isLayerEnabled('dengue')
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
