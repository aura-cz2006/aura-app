// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:aura/globals.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const IntroScreen());

typedef void isViewedCallBack(int isviewed);

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool permissionEnabled = false;
  loc.Location location = loc.Location();
  late loc.LocationData _locationData;
  late bool _serviceEnabled;
  late loc.PermissionStatus _permissionGranted;

  var addressController = TextEditingController(); // s edited content
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GeocodingPlatform geocoding = GeocodingPlatform.instance;
  late List<PageViewModel> listPagesViewModel;

  bool validAddress = false;

  List<PageViewModel> initPageViewModel(BuildContext context) {
    listPagesViewModel = [
      PageViewModel(
        title: "Title of first page",
        body: "The map tab",
        image: Center(
          child: Image.network(
              "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg",
              height: 175.0),
        ),
      ),
      PageViewModel(
        title: "Title of second page",
        body: "The community tab",
        image: Center(
          child: Image.network(
              "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
              height: 175.0),
        ),
      ),
      !validAddress ?
      PageViewModel(
        title: "Home Address",
        image: const Center(
          child: Icon(Icons.home, size: 50),
        ),
        bodyWidget: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: homeaddress_bar(),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: submitButton(context),
              ),
            ],
          ),
        ),
      ) :
      PageViewModel(
        title: "Request for Permission",
        image: const Center(
          child:
              Icon(Icons.location_on, color: Colors.lightBlueAccent, size: 30),
        ),
        bodyWidget: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "This app requires GPS services to function. Therefore, we require you to enable the permission for this app to access the location service."),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "I agree to allow this app to access the location service on this phone."),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: acceptButton(context),
              ),
            ],
          ),
        ),
      )
    ];

    return listPagesViewModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroductionScreen(
        pages: initPageViewModel(context),
        showNextButton: true,
        showBackButton: true,
        showSkipButton: false,
        showDoneButton: false,
        baseBtnStyle: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        next: const Text("Next", style: TextStyle(color: Colors.white),),
        back: const Text("Back", style: TextStyle(color: Colors.white),),
        // skip: const Text("Skip"),
        // done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    ); //Material App
  }

  Widget homeaddress_bar() {
    return Form(
      child: Form(
          key: _formKey,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: addressController,
            decoration: const InputDecoration(
                labelText: "Home Address",
                hintText: "Enter your home address here",
                border: OutlineInputBorder()),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              if (_formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus(); // exit keyboard
              }
            },
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Please enter an address.";
              }
            },
          )),
    );
  }

  Widget submitButton(BuildContext context) {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
        child: const Text("Submit"),
        onPressed: () async {
          //error message for empty homeaddress field
          if (!_formKey.currentState!.validate()) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                      elevation: 10,
                      scrollable: true,
                      content: Center(
                          child: Text("You have not entered an address.")));
                });
            return;
          }

          //Dialog boss to remind user to fill valid home address
          var addresses;
          try {
            print(addressController.text);
            addresses =
                await geocoding.locationFromAddress(addressController.text);
          } on Exception catch (e) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                      elevation: 10,
                      scrollable: true,
                      content: Center(
                          child: Text(
                              "You have entered an invalid address! \nPlease try again.")));
                });
          }
          var interest = addresses.first;

          //update User's homeaddress in manager
          userMgr.updateHomeAddress(userMgr.active_user_id,
              LatLng(interest.latitude, interest.longitude));

          // TODO GO NEXT PAGE
          validAddress = true;
        },
      );
    });
  }

  Widget acceptButton(BuildContext context) {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
        child: const Text("I Accept"),
        onPressed: () async {
          //Get user permission for location service
          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == loc.PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != loc.PermissionStatus.granted) return;
          }

          //Indicate that the phone has done onboarding before.
          Prefs.hasOnboarded();
          context.go("/tabs/map");
        },
      );
    });
  }
}
