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

  void openDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new searchOverlay();
        },
        fullscreenDialog: true));
  }

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
          backgroundColor: Colors.amber,
          onTap: (){},
        ),
        SpeedDialChild(
          child: Icon(Icons.search_outlined),
          label: "Search",
          backgroundColor: Colors.lightGreenAccent,
          onTap: (){
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    searchOverlay()));
            //Navigator.of(context).pop(MyReturnObject("some value");
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
  }
}


class searchOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: Center(
        child: Stack(
          children: <Widget>[
            searchBar(),
            submitButton()
          ],
        )
      )
    );
  }
}

Widget submitButton() {
  return Align(
    alignment: Alignment(0,0.8),
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
              )
          )
      ),
      child: Text("Submit"),
      onPressed: (){
        /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => createThread()),*/
      },
    ),
  );
}

Widget searchBar(){
  return Align(
    alignment: Alignment.center,
    child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Color(0x11111111),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Location",
              )
          ),
        )
    )
  );
}