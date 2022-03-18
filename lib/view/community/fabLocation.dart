import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(FAB());

class FAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title: Center(
                  child: Text('FAB')
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              )
          ),
          floatingActionButton: _locationFAB(),
        )
    );
  }
}


Widget _locationFAB(){
  return Padding(
    padding: EdgeInsets.only(bottom: 50, left: 20),
    child: locationFab(),
  );
}


class locationFab extends StatefulWidget {
  const locationFab({Key? key}) : super(key: key);

  @override
  _locationFabState createState() => _locationFabState();
}

class _locationFabState extends State<locationFab> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      heroTag: "unq2", //in case if we need multiple FAB in the same page
      backgroundColor: Colors.lightBlueAccent,
      icon: Icons.map,
      activeIcon: Icons.clear,
      children: [
        SpeedDialChild(
          child: Icon(Icons.gps_fixed),
          label: "Current",
          backgroundColor: Colors.amber
        ),
        SpeedDialChild(
          child: Icon(Icons.search_outlined),
          label: "Search",
          backgroundColor: Colors.lightGreenAccent
        ),
        SpeedDialChild(
          child: Icon(Icons.home),
          label: "Home",
          backgroundColor: Colors.redAccent,
        )
      ],
    );
  }
}
