import 'dart:io';

import 'package:aura/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

class searchOverlay extends StatefulWidget {
  OverlayEntry? entry;
  searchOverlay({Key? key, required this.entry}) : super(key: key);

  @override
  _searchOverlayState createState() => _searchOverlayState();
}

class _searchOverlayState extends State<searchOverlay> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.85),
          body: Center(
              child: Stack(
                children: <Widget>[searchBar(), submitButton(), closeButton()],
              ))),
    );
  }

  Widget closeButton(){
    return Align(
      alignment: Alignment(-0.8, -0.8),
      child: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.black,
        onPressed: closeOverlay,
      ),
    );
  }

  //Close overlay on back button
  Future<bool> _onWillPop() {
    closeOverlay();
    return Future.value(false);
  }

  Widget submitButton() {
    GeocodingPlatform geocoding =GeocodingPlatform.instance;
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return Align(
        alignment: Alignment(0, 0.8),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)))),
          child: Text("Submit"),
          onPressed: () async {
            //Check and display warning message if empty fields
            if (!_formKey.currentState!.validate()){
              return;
            }

            // Check for Internet Connection (required to look up validity of address)
            //If invalid address lke PO 123456, display error message box
            try {
              final internetConnection = await InternetAddress.lookup('example.com');
              if (internetConnection.isNotEmpty && internetConnection[0].rawAddress.isNotEmpty) {
                print('connected');
              }
            } on SocketException catch (e) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        elevation: 10,
                        scrollable: true,
                        content: Center(
                            child: Container(
                              child: Text("The following function requires internet connection!\n"
                                  "\nPlease connect to wifi or your personal data."),
                            )
                        )
                    );
                  });
              return;
            }
            print("Checkpoint Internet Verification: CLEARED\n");

            //VALIDITY FOR ADDRESS
            var coord;
            var coordinate;
            print("Checkpoint Address Validity: ENTERING\n");
            try{
              print("Checkpoint Address Validity: ENTERED\n");
              coord = await geocoding.locationFromAddress(searchController.text);
              coordinate = await coord.first;
            } on Exception catch (e) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        elevation: 10,
                        scrollable: true,
                        content: Center(
                            child: Container(
                              child: Text("You have entered an invalid address!\n"
                                  "\nPlease return to the previous page to enter a valid address."),
                            )
                        )
                    );
                  });
            }
            var addresses = await geocoding.locationFromAddress(searchController.text);
            var interest = addresses.first;
            print("Search location: ${LatLng( //TODO: Delete this line
                interest.latitude, interest.longitude)}");
            userMgr.updateLocation(LatLng(interest.latitude, interest.longitude));
            print("Saved Location: ${userMgr.getLocation()}");  //TODO: Delete this line
            closeOverlay();
          },
        ),
      );
    });
  }

  Widget searchBar() {
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
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: searchController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Location",
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Please enter an address.";
                    }
                  },
                ),
              ),
            )));
  }

  void closeOverlay(){
    widget.entry?.remove();
    widget.entry = null;
  }
}
