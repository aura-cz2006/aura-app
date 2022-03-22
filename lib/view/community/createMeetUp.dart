import 'package:aura/models/fabCreateMeetup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:aura/models/dateTime.dart';

void main() => runApp(createMeetUp());

class createMeetUp extends StatefulWidget {
  const createMeetUp({Key? key}) : super(key: key);

  @override
  _createMeetUpState createState() => _createMeetUpState();
}

class _createMeetUpState extends State<createMeetUp> {
  final titleController = TextEditingController(); //Saves edited title
  final contentController = TextEditingController(); //Saves edited content
  final locationController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(child: Text('Create Thread')),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Center(
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(5), child: titleField()),
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
                  onClicked: (DateTime val) =>
                      setState(() => selectedDate = val))),
        ],
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
                //Create thread
                /*meetup_manager.addMeetUp(
                    titleController.text,
                    contentController.text,
                    selectedDate,
                    location,
                    content,
                    userManager.userID //Not yet available
                  );*/
                // Navigator.pop(context); //Return to previous, but updated threadlistview*/
              });
            },
          ),
        ),
      ),
    );
  }
}
