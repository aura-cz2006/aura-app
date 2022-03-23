import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Point {
  LatLng coords = LatLng(0, 0);
  IconData? icon;
  Color? color;

  Point(this.coords, this.icon, this.color);
}