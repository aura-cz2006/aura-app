import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Taxi {
  String taxiID;
  LatLng coords = LatLng(0, 0);
  int bearing;
  String? company;
  Color? color;

  Taxi(this.taxiID, this.coords, this.bearing, this.company, this.color);
}
