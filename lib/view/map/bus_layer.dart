import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

//use a fitted box for the popup, figure out how to make it look nice nice with the uh line line

void main() => runApp(const MyApp());

class Point {
  LatLng coords = LatLng(0,0);
  IconData? icon;
  Color? color;
  Point(this.coords, this.icon, this.color);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body:  Center(
              child:
              busButton()
          )
      ),
    );
  }
}



class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.purpleAccent,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.directions_bus_outlined),
            color: Colors.black,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}


List<Point> _pointList = [
  new Point(LatLng(1.348036, 103.680644), Icons.location_pin , Colors.deepOrange[800]), // lwn 179 179A
  new Point(LatLng(1.347993, 103.68037), Icons.location_pin , Colors.deepOrange[800]), // blk 2 199
];


Widget busStopDetails(String busStopName,String busStopNo, String busNo, String busWaitingTime) {
  return Container(
    padding: const EdgeInsets.all(32),
    color: Colors.red[100],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child:
          Text(busStopName + "         " +  busStopNo
            , style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          busNo + "         " + busWaitingTime,
          style: TextStyle(
          ),
        ),
      ],
    ),
  );
}


Widget busRowDisplay(String busNo, String waitTime1, String waitTime2) {
  return Center(
    child: Card(
      child: InkWell(
        splashColor: Colors.red.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("    "+ busNo +"   "),
              Text(waitTime1+ "   "),
              Text(waitTime2 + "    "),

            ],
          ),
        ),
      ),
    ),
  );
}

class busButton extends StatefulWidget {
  @override
  _busButtonState createState() => _busButtonState();
}

class _busButtonState extends State<busButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.directions_bus_outlined),
            color: Colors.black,
          )
        ],
      )
    );
  }
}


/* info for bus to display 2 bustops
* bus stops 1
* Lee Wee Nam Library (Nanyang Drive) B27211
   179        4m  7m
 * 179A       2m  6m
 * Lat and long: 1.3480° N, 103.6806° E 1.348036°103.680644°

*
* bus stops 2
* Block 2 (Nanyang Drive) B27219
* 199       1m  10m
* 1.347993° 103.68037°
* */

// Icons.location_pin),
// color: Colors.deepOrange[800],