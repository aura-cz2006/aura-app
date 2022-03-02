import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  MapController _mapController = MapController();
  List<LatLng> _latLngList = [
    LatLng(1.3483, 103.6831), // ntu
    LatLng(1.3644, 103.9915), // changi airport
  ];
  List<Marker> _markers = [];

  @override
  void initState() {
    // initialise markers at each point in latLngList
    _markers = _latLngList
        .map((point) => Marker(
      point: point,
      width: 60,
      height: 60,
      builder: (context) => const Icon(
        Icons.pin_drop,
        size: 60,
        color: Colors.redAccent,
      ),
    ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Tab'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(1.3521, 103.8198), // singapore
          bounds: LatLngBounds.fromPoints(_latLngList),
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
