import 'dart:async';

import 'package:aura/view/map/amenitieschip.dart';
import 'package:aura/view/map/meetups_layer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> meetupMarkersList = [];


class Point {
  LatLng coords = LatLng(0,0);
  IconData? icon;
  Color? color;
  Point(this.coords, this.icon, this.color);
}

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  MapController _mapController = MapController();
  List<Point> _pointList = [
    new Point(LatLng(1.3483, 103.6831), Icons.pin_drop, Colors.redAccent), // ntu
    new Point(LatLng(1.3644, 103.9915), Icons.pin_drop, Colors.blueAccent), // changi airport
  ];
  List<Marker> _markers = [];

  @override
  void initState() {
    // initialise markers at each point in latLngList
    _markers = _pointList
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(),
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(1.3521, 103.8198), // singapore
                bounds: LatLngBounds.fromPoints(_pointList.map((point) => point.coords).toList()),
                zoom: 5,
                minZoom: 0,
                maxZoom: 18,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return const Text("© OpenStreetMap contributors");
                    },
                  updateInterval: 1,
                  //rebuild: ,

                ),
                MarkerLayerOptions(
                  markers: _markers,
                  rotate: true,
                ),

                MarkerLayerOptions(
                  markers: meetupMarkersList,
                  rotate: true,

    ),
                  ],
            ),
            rowChips(),
             Positioned(
              right: 20,
              top:100,
              child: MeetUpsButton(),
            )
          ],
        )
    );
  }
}



