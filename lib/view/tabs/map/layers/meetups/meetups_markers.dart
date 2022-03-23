import 'package:aura/managers/map_manager.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

List<Marker> meetupsMarkers(MapManager mapManager, Meetup_Manager meetupManager) {
  List<Marker> meetupMarkers = !mapManager.selectedLayers.contains('meetups')
      ? []
      : meetupManager.getMeetupsSortedByTimeOfMeetUp()
      .map((meetup) => Point(meetup.location, Icons.people, Colors.deepPurple))
      .map((point) =>
      Marker(
        point: point.coords,
        width: 60,
        height: 60,
        builder: (context) =>
            Icon(
              point.icon,
              size: 60,
              color: point.color,
            ),
      ))
      .toList();

  return meetupMarkers;
}
