import 'package:flutter/material.dart';
import 'package:aura/globals.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(IntroScreen());

typedef void isViewedCallBack(int isviewed);

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  var addressController = TextEditingController(); // s edited content
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GeocodingPlatform geocoding = GeocodingPlatform.instance;
  late List<PageViewModel> listPagesViewModel;


  List<PageViewModel> initPageViewModel(BuildContext context){
    listPagesViewModel = [
      PageViewModel(
        title: "Title of first page",
        body: "The map tab",
        image: Center(
          child: Image.network("https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", height: 175.0),
        ),
      ),
      PageViewModel(
        title: "Title of second page",
        body: "The community tab",
        image: Center(
          child: Image.network("https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg", height: 175.0),
        ),
      ),
      PageViewModel(
        title: "Home Address",
        image: const Center(
          child: Icon(Icons.home,size:30),
        ),
        bodyWidget: Center(
          child:Column(
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
      ),
    ];

    return listPagesViewModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroductionScreen(
        pages: initPageViewModel(context),
        showNextButton: false,
        showBackButton: false,
        showSkipButton: false,
        showDoneButton: false,
        // skip: const Text("Skip"),
        // done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

      ),
    );//Material App
  }

  Widget homeaddress_bar(){
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
        child: Text("Submit"),
        onPressed: () async {
          var addresses = await geocoding.locationFromAddress(addressController.text);
          var interest = addresses.first;
          print("Search location: ${LatLng( //TODO: Delete this line
              interest.latitude, interest.longitude)}");


          //Error message for empty field
          if (!_formKey.currentState!.validate()) {
            return;
          }
          //update User's homeaddress in manager
          userMgr.updateHomeAddress(userMgr.active_user_id,
              LatLng(interest.latitude, interest.longitude));
          //Indicate that the phone has done onboarding before.
          Prefs.hasOnboarded();
          context.go("/tabs/map");
        },
      );
    });
  }


}
