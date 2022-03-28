import 'package:flutter/material.dart';
import 'package:aura/view/community/datetime_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:aura/widgets/app_bar_back_button.dart';

void main() => runApp(CreateMeetupView());

class CreateMeetupView extends StatefulWidget {
  const CreateMeetupView({Key? key}) : super(key: key);

  @override
  _CreateMeetupViewState createState() => _CreateMeetupViewState();
}

class _CreateMeetupViewState extends State<CreateMeetupView> {
  final titleController = TextEditingController(); //Saves edited title
  final descriptionController = TextEditingController(); //Saves edited content
  final locationController = TextEditingController();
  final attendeeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //For validating empty fields

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(child: Text('Create Meetup')),
            automaticallyImplyLeading: true,
            leading: AppBarBackButton()),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              children: [
                Padding(padding: EdgeInsets.all(5), child: titleField()),
                Padding(padding: EdgeInsets.all(5), child: attendeeField()),
                Padding(padding: EdgeInsets.all(5), child: selectTime()),
                Padding(padding: EdgeInsets.all(5), child: locationField()),
                Padding(padding: EdgeInsets.all(5), child: contentField()),
                Padding(padding: EdgeInsets.all(5), child: submitButton(context))
              ],
            ),
          ),
        )
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
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter an location.";
          }
        },
      );

  Widget selectTime() => Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 8, bottom: 5),
            child:
                Text("Date & Time of Meetup: ", style: TextStyle(fontSize: 15)),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5, left: 8, right: 5, bottom: 5),
              child: new datetime_picker(
                  date_reference: DateTime.now(),
                  onClicked: (DateTime val) =>
                      setState(() => selectedDate = val))),
        ],
      );

  Widget attendeeField() => TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: attendeeController,
        decoration: InputDecoration(
            labelText: "Participant size",
            hintText: "Enter the size of participant",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter the number of max attendee.";
          }
        },
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
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter a title.";
          }
        },
      );

  Widget contentField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: descriptionController,
        decoration: InputDecoration(
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter an description.";
          }
        },
      );

  Widget submitButton(BuildContext context) {
    return Align(
        child: SizedBox(
      width: 100,
      height: 50,
      child: Card(
        child: Consumer2<Meetup_Manager, User_Manager>(
            builder: (context, meetupMgr, userMgr, child) {
          return ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              //Check and display warning message if empty fields
              if (!_formKey.currentState!.validate() || selectedDate.isBefore(DateTime.now())){
                return;
              }
              setState(() {
                print(Text('''Title: ${titleController.text}
                Date&Time: ${selectedDate}
                Location: 1.3483, 103.6831
                Content: ${descriptionController.text}
                '''));
                //Create thread
                meetupMgr.addMeetup(
                  selectedDate,
                  LatLng(1.1, 2.2),
                  userMgr.active_user_id,
                  int.parse(attendeeController.text),
                  titleController.text,
                  descriptionController.text,
                );
                context.pop();
              });
            },
          );
        }),
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    attendeeController.dispose();
    super.dispose();
  }
}
