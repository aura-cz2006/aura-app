import 'dart:core';

import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/view/community/datetime_picker.dart';
import 'package:provider/provider.dart';

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

  final titleController = TextEditingController(); //Saves edited title
  final descriptionController = TextEditingController(); //Saves edited content
  final locationController = TextEditingController();
  final maxAttendeesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //For validating empty fields

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
            latlngToString(meetupMgr.getMeetupByID(widget.meetupID).location)),
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

  Widget maxAttendeesField() { //todo raise error if new value < currNumAttendees
    return Consumer<Meetup_Manager>(builder: (context, meetupMgr, child) {
      return TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
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
                onPressed: () {
                  setState(() {
                    //Check and display warning message if empty fields
                    if (!_formKey.currentState!.validate()){
                      return;
                    }

                    var new_location = LatLng(12.1,21.3); // todo read new location
                    meetupMgr.editMeetup(widget.meetupID, selectedDate??meetupMgr.getMeetupByID(widget.meetupID).timeOfMeetUp, titleController.text,
                        descriptionController.text, new_location, int.parse(maxAttendeesController.text));
                    context.pop();
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

String latlngToString(LatLng coord) {
  return (coord.latitude.toString() + ", " + coord.longitude.toString());
}
