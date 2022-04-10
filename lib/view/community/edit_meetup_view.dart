import 'dart:core';
import 'dart:io';

import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/view/community/datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  String meetupID = "1";
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => Meetup_Manager()),
    ], child: EditMeetupView(meetupID: meetupID)),
  );
}

class EditMeetupView extends StatefulWidget {
  final String meetupID;

  const EditMeetupView({Key? key, required this.meetupID}) : super(key: key);

  @override
  _EditMeetupViewState createState() => _EditMeetupViewState();
}

class _EditMeetupViewState extends State<EditMeetupView> {
  DateTime? selectedDate;
  GeocodingPlatform geocoding = GeocodingPlatform.instance;
  late var addresses;
  late var interest;

  final titleController = TextEditingController(); //Saves edited title
  final descriptionController = TextEditingController(); //Saves edited content
  final locationController = TextEditingController();
  final maxAttendeesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //For validating empty fields
  late String address;


  TextEditingController _setControllerText(
      TextEditingController ctrl, String text) {
    ctrl.text = text;
    return ctrl;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AuraAppBar(
            title: const Text('Edit Meetup')),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              children: [
                Padding(padding: const EdgeInsets.all(5), child: titleField()),
                Padding(padding: const EdgeInsets.all(5), child: maxAttendeesField()),
                Padding(padding: const EdgeInsets.all(5), child: selectTime()),
                Padding(padding: const EdgeInsets.all(5), child: locationField()),
                Padding(padding: const EdgeInsets.all(5), child: descriptionField()),
                Padding(padding: const EdgeInsets.all(5), child: submitButton(context))
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget locationField() {
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _setControllerText(locationController,
            meetupMgr.getMeetupByID(widget.meetupID).address),
        decoration: const InputDecoration(
            labelText: "Location",
            hintText: "Enter the location of meet up here",
            border: OutlineInputBorder()),
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter a location.";
          }
        },
      );
    });
  }

  Widget selectTime() {
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 15, bottom: 5),
            child: Text("Time & Date", style: TextStyle(fontSize: 20)),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 5),
              child: DatetimePicker(
                  date_reference:
                      meetupMgr.getMeetupByID(widget.meetupID).timeOfMeetUp,
                  onClicked: (DateTime val) =>
                      setState(() => selectedDate = val))),
        ],
      );
    });
  }

  Widget maxAttendeesField() {
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return TextFormField(
        controller: _setControllerText(maxAttendeesController,
            meetupMgr.getMeetupByID(widget.meetupID).maxAttendees.toString()),
        decoration: const InputDecoration(
            labelText: "Number of attendees",
            hintText: "Enter the maximum number of attendees",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else if (int.parse(value) < meetupMgr.getMeetupByID(widget.meetupID).rsvpAttendees.length) {
            return "Invalid maximum number of attendees. ${meetupMgr.getMeetupByID(widget.meetupID).rsvpAttendees.length} people have already RSVPed to this meetup.";
          } else if (int.parse(value)<=0) {
            return "Please enter a valid number";
          } else {
            return "Please enter the maximum number of attendees.";
          }
        },
      );
    });
  }

  Widget titleField() {
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: _setControllerText(titleController,
            meetupMgr.getMeetupByID(widget.meetupID).title ?? ""),
        decoration: const InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of your post here",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.next,
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter a title.";
          }
        },
      );
    });
  }

  Widget descriptionField() {
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _setControllerText(descriptionController,
            meetupMgr.getMeetupByID(widget.meetupID).description ?? ""),
        decoration: const InputDecoration(
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter a description.";
          }
        },
      );
    });
  }

  Widget submitButton(BuildContext context) {
    return Align(
      child: Consumer<Meetup_Manager>(
        builder: (context, meetupMgr, child) {
          return SizedBox(
            width: 100,
            height: 50,
            child: Card(
              child: ElevatedButton(
                child: const Text("Submit"),
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
                                    child: const Text("The following function requires internet connection!\n"
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
                    coord = await geocoding.locationFromAddress(locationController.text);
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
                                    child: const Text("You have entered an invalid address!\n"
                                        "\nPlease return to the previous page to enter a valid address."),
                                  )
                              )
                          );
                        });
                  }
                  //Check if correct
                  print(titleController.text);
                  print(descriptionController.text);
                  print(int.parse(maxAttendeesController.text));
                  print(selectedDate??meetupMgr.getMeetupByID(widget.meetupID).timeOfMeetUp);
                  print(LatLng(coordinate.latitude, coordinate.longitude));
                  //Post thread to server

                  await MeetupsController.createMeetup(
                      title: titleController.text,
                      content: descriptionController.text,
                      maxAttendees: int.parse(maxAttendeesController.text),
                      timeofMeetup: selectedDate??meetupMgr.getMeetupByID(widget.meetupID).timeOfMeetUp,
                      location: LatLng(coordinate.latitude, coordinate.longitude)).then((statcode)
                  {
                    //Check if Post was successful
                    if (statcode == 200) {
                      print("Patch Meetup Success!");
                      setState(() async {
                        await MeetupsController.fetchMeetups(context);
                        context.pop();
                      });
                    }
                    //Failure Message
                    if (statcode != 200){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                elevation: 10,
                                scrollable: true,
                                content: Center(
                                    child: Container(
                                      child: const Text("Unable to create meetup.\n"
                                          "\n Please try again."),
                                    )
                                )
                            );
                          });
                    }
                  });
                },
              ),
            ),
          );
    }
    ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    maxAttendeesController.dispose();
    super.dispose();
  }


}

