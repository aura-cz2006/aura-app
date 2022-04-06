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
              promoteId: 'Name', // TODO TESTING
            ));
        await controller.addFillLayer(
            "dengue_clusters",
            "dengue_polygon",
            FillLayerProperties(
                fillColor: "#EF9A9A",
                // circleRadius: ,
                fillOpacity: 0.7,
                visibility: mapMgr.isLayerEnabled('dengue')
                    ? "visible" // todo broken bc cant find enum
                    : "none"));
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

      void initTaxisLayer() async {
        MapController.fetchTaxiData(context); // todo doesnt work
        await controller.addSource(
          "taxi_locations",
          GeojsonSourceProperties(
            attribution: "Taxi availability data from data.gov.sg",
            data: // URL to a GeoJSON file, or inline GeoJSON
                MapController.getTaxiDataURL(), //todo use mapMgr.taxiData, but it gives {}?
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
              iconColor: "#7C4DFF", // colour broken
              iconOpacity: 1,
              iconImage: "restaurant-pizza-15", // todo no ppl icon
              iconSize: 2,
            ));
      }

      void initAmenitiesLayer() async {
        MapController.fetchSelectedAmenities(context);
        Map<AmenityCategory, dynamic> amenitiesData =
            MapController.getAmenitiesData(context);
        print(amenitiesData);
        amenitiesData.forEach((category, data) async {
          await controller.addSource(
            "amenities_${CategoryConvertor.getQueryString(category)}_locations",
            GeojsonSourceProperties(
              data: data,
            ),
          );
          await controller.addSymbolLayer(
            "amenities_${CategoryConvertor.getQueryString(category)}_locations",
            "amenities_${CategoryConvertor.getQueryString(category)}_icons",
            SymbolLayerProperties(
              // iconColor: "#7C4DFF", // colour broken
              iconOpacity: 1,
              iconImage: MapController.getAmenityCategoryIcon(
                  category), // no ppl icon
              iconSize: 2,
            ),
          );
        });
      }

      // add map layers after style is loaded
      void _onStyleLoaded() async {
        initDengueClustersLayer();
        initTaxisLayer();
        initMeetupsLayer();
        initAmenitiesLayer();

        Timer timer = Timer.periodic(
            //todo refresh data periodically
            const Duration(seconds: 30), (t) {
          // controller.setGeoJsonSource(
          //     "dengue_clusters", mapMgr.isLayerEnabled('dengue') ? MapController.getDengueDataURL(context) : {});
          controller.setGeoJsonSource(
              "meetup_locations", MapController.getMeetupsData(context));
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
                  mapMgr.toggleLayer('taxis');
                },
                child: const Icon(Icons.car_repair, color: Colors.black),
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
                },
                child: const Icon(Icons.people, color: Colors.black),
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
                },
                child: const Icon(Icons.bug_report, color: Colors.black),
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
