import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

MarkerLayerOptions meetupsLayer(MapManager mapManager, MeetupManager meetupManager) {
  List<Marker> meetupMarkers = !meetupManager.selectedLayers.contains('meetups')
      ? []
      : meetupManager.meetups
          .map((meetup) => Point(meetup.coords, Icons.people, Colors.orange))
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
    markers: meetupMarkers,
    rotate: true,
  );
}
