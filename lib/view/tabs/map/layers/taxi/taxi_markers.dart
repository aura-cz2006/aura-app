import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/point.dart';
import 'package:aura/models/taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

List<Marker> taxiMarkers(List<Taxi> taxis, bool enabled) {
  print(enabled ? 'taxi enabled' : 'taxiDisabled');
  print(enabled);
  List<Marker> _taxiMarkers = !enabled
      ? []
      : taxis
      .map((taxi) => Point(taxi.coords, Icons.car_repair, Colors.yellow))
      .map((point) =>
      Marker(
        point: point.coords,
        width: 32,
        height: 32,
        builder: (context) =>
            Icon(
              point.icon,
              size: 60,
              color: point.color,
            ),
      ))
      .toList();

  return _taxiMarkers;
}
