// import 'dart:html';

import 'package:aura/view/news/searchOverlay_view.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
          floatingActionButton: locationFABWrap(),
        )
    );
  }
}


Widget locationFABWrap(){
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
  OverlayEntry? entry;
  Location location = Location();
  late LocationData _locationData;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;


  void showOverlay(){
    entry = OverlayEntry(builder: (context) => searchOverlay(entry: entry));

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return SpeedDial(
        heroTag: "unq2", //in case if we need multiple FAB in the same page
        backgroundColor: Colors.lightBlueAccent,
        icon: Icons.map,
        activeIcon: Icons.clear,
        children: [
          SpeedDialChild(
            child: Icon(Icons.gps_fixed),
            label: "Current",
            backgroundColor: Colors.amber,
            onTap: ()async{
              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled){
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) return;
              }
              //TODO: Ask for permission during onboarding
              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied){
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) return;
              }

              location.changeSettings(); //Ensure accuracy is high
              _locationData = await location.getLocation();
              print("Current Location: ${LatLng(_locationData.latitude!, _locationData.longitude!)}"); //TODO: Delete this line
              setState(() {
                userMgr.updateLocation(LatLng(_locationData.latitude!, _locationData.longitude!));
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.search_outlined),
            label: "Search",
            backgroundColor: Colors.lightGreenAccent,
            onTap: (){
              showOverlay();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.redAccent,
            onTap: (){},
          )
        ],
      );
    });
  }
}