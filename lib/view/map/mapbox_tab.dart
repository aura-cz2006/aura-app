import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxTab extends StatefulWidget {
  const MapboxTab({Key? key}) : super(key: key);

  @override
  State<MapboxTab> createState() => _MapboxTabState();
}

class _MapboxTabState extends State<MapboxTab> {
  @override
  Widget build(BuildContext context) {

    MapboxMapController? controller;


    _showSnackBar(String type, String id) {
      final snackBar = SnackBar(
          content: Text('Tapped $type $id',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _onFillTapped(Fill fill) {
      _showSnackBar('fill', fill.id);
    }

    void _onCircleTapped(Circle circle) {
      _showSnackBar('circle', circle.id);
    }

    void _onLineTapped(Line line) {
      _showSnackBar('line', line.id);
    }

    void _onSymbolTapped(Symbol symbol) {
      _showSnackBar('symbol', symbol.id);
    }


    void _onMapCreated(MapboxMapController mbController) {
      controller = mbController;
      controller?.onFillTapped.add(_onFillTapped);
      controller?.onCircleTapped.add(_onCircleTapped);
      controller?.onLineTapped.add(_onLineTapped);
      controller?.onSymbolTapped.add(_onSymbolTapped);
    }

    @override
    void dispose() {
      controller?.onFillTapped.remove(_onFillTapped);
      controller?.onCircleTapped.remove(_onCircleTapped);
      controller?.onLineTapped.remove(_onLineTapped);
      controller?.onSymbolTapped.remove(_onSymbolTapped);
      super.dispose();
    }

    void _onStyleLoaded() {
      controller!.addCircle(
        const CircleOptions(
          geometry: LatLng(-33.881979408447314, 151.171361438502117),
          circleStrokeColor: "#00FF00",
          circleStrokeWidth: 2,
          circleRadius: 16,
        ),
      );
      controller!.addCircle(
        const CircleOptions(
          geometry: LatLng(-33.894372606072309, 151.17576679759523),
          circleStrokeColor: "#00FF00",
          circleStrokeWidth: 2,
          circleRadius: 30,
        ),
      );
      controller!.addSymbol(
        const SymbolOptions(
            geometry: LatLng(1.353944, 103.685979),
            iconImage: "car-15",
            iconColor: "#F7B731",
            iconSize: 2),
      );
      controller!.addLine(
        const LineOptions(
          geometry: [
            LatLng(-33.874867744475786, 151.170627211986584),
            LatLng(-33.881979408447314, 151.171361438502117),
            LatLng(-33.887058805548882, 151.175032571079726),
            LatLng(-33.894372606072309, 151.17576679759523),
            LatLng(-33.900060683994681, 151.15765587687909),
          ],
          lineColor: "#0000FF",
          lineWidth: 20,
        ),
      );

      controller!.addFill(
        const FillOptions(
          geometry: [
            [
              LatLng(-33.901517742631846, 151.178099204457737),
              LatLng(-33.872845324482071, 151.179025547977773),
              LatLng(-33.868230472039514, 151.147000529140399),
              LatLng(-33.883172899638311, 151.150838238009328),
              LatLng(-33.894158309528244, 151.14223647675135),
              LatLng(-33.904812805307806, 151.155999294764086),
              LatLng(-33.901517742631846, 151.178099204457737),
            ],
          ],
          fillColor: "#FF0000",
          fillOutlineColor: "#000000",
        ),
      );
    }

    // return const Scaffold(
    //   body:Center(
    //     child: Text("hi"),
    //   )
    // );


    return Scaffold(
        body: MapboxMap(
            accessToken:
                "pk.eyJ1IjoicmVhbGR5bGxvbiIsImEiOiJja3AyczZ0aHAwMDYyMndwNmg5Yng1em14In0.zEZQ4arU9f09eFsRTUYgSg",
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
            annotationOrder: const [
              AnnotationType.fill,
              AnnotationType.line,
              AnnotationType.circle,
              AnnotationType.symbol,
            ],
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: const CameraPosition(
              zoom: 14.0,
              target: LatLng(1.353944, 103.685979),
            )));
  }
}
