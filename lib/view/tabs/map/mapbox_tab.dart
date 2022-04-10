import 'dart:async';
import 'dart:math';
import 'package:aura/controllers/map_controller.dart';
import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:aura/view/tabs/map/amenities_filter_chips.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<MapManager, Meetup_Manager>(
        builder: (context, mapMgr, meetupMgr, child) {
      void _onMapCreated(MapboxMapController mbController) {
        controller = mbController;
      }

      // initialise map layers
      void initDengueLayer() async {
        await controller.addSource(
            "dengue_clusters",
            GeojsonSourceProperties(
              attribution: "Dengue clusters data from data.gov.sg",
              data: // URL to a GeoJSON file, or inline GeoJSON
                  MapController.getDengueDataURL(),
            ));
        await controller.addFillLayer("dengue_clusters", "dengue_polygon",
            const FillLayerProperties(fillColor: "#EF9A9A", fillOpacity: 0.7));
      }

      void initTaxisLayer() async {
        await controller.addSource(
          "taxi_locations",
          GeojsonSourceProperties(
            attribution: "Taxi availability data from data.gov.sg",
            data: // URL to a GeoJSON file, or inline GeoJSON
                MapController
                    .getTaxiDataURL(),
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

      void initMeetupsLayer() async {
        MeetupsController.fetchMeetups(context);
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
              iconImage: "heart-15",
              iconSize: 2,
            ));
      }

      void initAmenitiesLayer() async {
        Map<AmenityCategory, dynamic> amenitiesData =
            MapController.getAmenitiesGeojson(context);
        for (AmenityCategory category in mapMgr.categories) {
          String queryString = CategoryConvertor.getQueryString(category)!;
          await controller.addSource(
            "amenities_${queryString}_locations",
            GeojsonSourceProperties(
              data: amenitiesData[category],
            ),
          );
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
                iconImage: "heart-15",
                iconSize: 2,
              ));
        }
      }

      void _onStyleLoaded() async {
        initDengueLayer();
        initTaxisLayer();
        initMeetupsLayer();
        initAmenitiesLayer();

        // refresh data periodically
        Timer.periodic(const Duration(seconds: 30), (t) {
          updateTaxiLayer();
          updateDengueLayer();
          updateMeetupsLayer();
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
