import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

List<Marker> taxiMarkers(MapManager mapManager) {
  List<Marker> _taxiMarkers = !mapManager.selectedLayers.contains('taxi')
      ? []
      : mapManager.taxis
          .map((taxi) => Point(taxi.coords, Icons.car_repair, Colors.yellow))
          .map((point) => Marker(
                point: point.coords,
                width: 32,
                height: 32,
                builder: (context) => Icon(
                  point.icon,
                  size: 60,
                  color: point.color,
                ),
              ))
          .toList();

  return _taxiMarkers;
}
