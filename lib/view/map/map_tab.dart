import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Point {
  LatLng coords = LatLng(0,0);
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
      // appBar: AppBar(
      //   title: const Text('Map Tab'),
      // ),
      body: FlutterMap(
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
            }
          ),
          MarkerLayerOptions(
            markers: _markers,
            rotate: true,
          ),
        ],
      ),
    );
  }
}
