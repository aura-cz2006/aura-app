import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(test());

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
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
  TextEditingController searchController = TextEditingController();
  OverlayEntry? entry;
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      heroTag: "unq2", //in case if we need multiple FAB in the same page
      backgroundColor: Colors.lightBlueAccent,
      icon: Icons.map,
      activeIcon: Icons.clear,
      children: [
        SpeedDialChild( //TODO: Pass location data to some manager
          child: Icon(Icons.gps_fixed),
          label: "Current",
          backgroundColor: Colors.amber,
          onTap: (){},
        ),
        SpeedDialChild( //TODO: Pass location data to some manager
          child: Icon(Icons.search_outlined),
          label: "Search",
          backgroundColor: Colors.lightGreenAccent,
          onTap: (){
            SearchOverlayView();
          },
        ),
        SpeedDialChild( //TODO: Pass location data to some manager
          child: Icon(Icons.home),
          label: "Home",
          backgroundColor: Colors.redAccent,
          onTap: (){},
        )
      ],
    );
  }

  void SearchOverlayView(){
    entry = OverlayEntry(
        builder: (context) => Scaffold(
            backgroundColor: Colors.white.withOpacity(0.85),
            body: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment(0,0),
                      child: SearchBar(),
                    ),
                    Align( //Submit Button
                      alignment: Alignment(0,0.8),
                      child: ElevatedButton(
                        child: Text("Submit"),
                        onPressed: (){
                          setState(() {
                            print(searchController.text);
                            //Pass data to map manager?
                            // context.pop();
                          });
                          hideSearchOverlay();
                        },
                      ),
                    )
                  ],
                )
            )
        )
    );

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void hideSearchOverlay(){
    entry?.remove();
    entry = null;
  }

  Widget SearchBar() => TextFormField(
    decoration: InputDecoration(
        labelText: "Search Bar",
        hintText: "Enter the location here",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        )
    ),
    maxLines: null,
    controller: searchController,
  );
}