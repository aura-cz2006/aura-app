import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

MarkerLayerOptions taxiMarkerLayer(MapManager mapManager) {
  List<Marker> _taxiMarkers = !mapManager.selectedLayers.contains('taxi')
      ? []
      : mapManager.taxis
          .map((taxi) => Point(taxi.coords, Icons.car_repair, Colors.orange))
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

  return MarkerLayerOptions(
    markers: _taxiMarkers,
    rotate: true,
  );
}
