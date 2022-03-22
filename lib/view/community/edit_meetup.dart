import 'dart:core';
// import 'package:aura/managers/meetup_manager.dart';
// import 'package:aura/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aura/models/meetup.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/models/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:aura/models/datetime.dart';

void main() {
  User user = User("USER_ID", "USERNAME");
  // Thread test = Thread("TEST_ID", "This is the Title.", user,
  //     "This is the thread content.", DateTime.now());

  Meetup meetup = Meetup(DateTime(2100), LatLng(10.000002, 12.00001), "ABC",
      user, 10, "Party", "I don't know", DateTime.now());
  runApp(editMeetUp(meetupID: "1",meetup: meetup));
}

class editMeetUp extends StatefulWidget {
  Meetup meetup;
  final String meetupID;

  editMeetUp({required this.meetup, required this.meetupID});

  @override
  _editMeetUpState createState() => _editMeetUpState();
}

class _editMeetUpState extends State<editMeetUp> {
  late String title = widget.meetup.title ?? '';
  late String content = widget.meetup.description ?? '';
  late DateTime selectedDate = widget.meetup.timeOfMeetUp;
  late int size = widget.meetup.maxAttendees;
  late LatLng location = widget.meetup.location;

  final titleController = TextEditingController(); //Saves edited title
  final contentController = TextEditingController(); //Saves edited content
  final locationController = TextEditingController();
  final sizeController = TextEditingController();
  //Saves edited content

  @override
  void initState() {
    super.initState();
    titleController.text = title; //Prefill title with original thread title
    contentController.text =
        content; //Prefill content with original content title
    locationController.text = latlngToString(location);
    sizeController.text = size.toString();
    selectedDate = widget.meetup.timeOfMeetUp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(child: Text('Edit Thread')),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5), child: titleField()),
              Padding(padding: EdgeInsets.all(5), child: sizeField()),
              Padding(padding: EdgeInsets.all(5), child: selectTime()),
              Padding(padding: EdgeInsets.all(5), child: locationField()),
              Padding(padding: EdgeInsets.all(5), child: contentField()),
              Padding(padding: EdgeInsets.all(5), child: submitButton(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget locationField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: locationController,
        decoration: InputDecoration(
            labelText: "Location",
            hintText: "Enter the location of meet up here",
            border: OutlineInputBorder()),
      );

  Widget selectTime() => Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 15, bottom: 5),
            child: Text("Time & Date", style: TextStyle(fontSize: 20)),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 5),
              child: new datetime_picker(
                  date_reference: selectedDate,
                  onClicked: (DateTime val) =>
                      setState(() => selectedDate = val))),
        ],
      );

  Widget sizeField() => TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: sizeController,
        decoration: InputDecoration(
            labelText: "Participant size",
            hintText: "Enter the size of participant",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      );

  Widget titleField() => TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: titleController,
        decoration: InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of your post here",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.next,
      );

  Widget contentField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: contentController,
        decoration: InputDecoration(
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
      );

  Widget submitButton(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 100,
        height: 50,
        child: Card(
          child: ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              setState(() {
                print(Text('''Title: ${titleController.text}
                Date&Time: ${selectedDate}
                Location: 1.3483, 103.6831
                Content: ${contentController.text}
                '''));
                //Edit Meetup
                /*meetupMgr.editMeetUp(
                    widget.meetupID,
                    titleController.text,
                    contentController.text,
                    int.parse(sizeController.text),
                    selectedDate,
                    LatLng(12.1,21.3),      //
                    content,
                    userManager.userID //Not yet available
                  );*/
                Navigator.pop(context);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    locationController.dispose();
    sizeController.dispose();
    super.dispose();
  }
}

String latlngToString(LatLng coord) {
  return (coord.latitude.toString() + ", " + coord.longitude.toString());
}