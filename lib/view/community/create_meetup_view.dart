import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:aura/view/community/datetime_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const CreateMeetupView());

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
        appBar: AuraAppBar(
            title: const Text('Create Meetup')),
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

  Widget selectTime() => Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 8, bottom: 5),
            child:
                Text("Date & Time: ", style: TextStyle(fontSize: 15)),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5, left: 8, right: 5, bottom: 5),
              child: DatetimePicker(
                  date_reference: DateTime.now(),
                  onClicked: (DateTime val) =>
                      setState(() => selectedDate = val))),
        ],
      );

  Widget attendeeField() => TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: attendeeController,
        decoration: const InputDecoration(
            labelText: "Participant size",
            hintText: "Enter the size of participant",
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

  Widget titleField() => TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: titleController,
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

  Widget contentField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: descriptionController,
        minLines: 10,
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

  Widget submitButton(BuildContext context) {
    return Align(
        child: SizedBox(
      width: 100,
      height: 50,
      child: Card(
        child: Consumer2<Meetup_Manager, User_Manager>(
            builder: (context, meetupMgr, userMgr, child) {
          return ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              //Check and display warning message if empty fields
              if (!_formKey.currentState!.validate() || selectedDate.isBefore(DateTime.now())){
                return;
              }
              setState(() async {
                int response = await MeetupsController.createMeetup(title: titleController.text,
                    content: descriptionController.text, maxAttendees: int.parse(attendeeController.text),
                    userID: userMgr.active_user_id, timeofMeetup: selectedDate, location: LatLng(1.1, 2.2));
                if (response == 200) {print("Success");}

                //Failure Message
                if (response != 200){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            elevation: 10,
                            scrollable: true,
                            content: Center(
                                child: Container(
                                  child: Text("Unable to create meetup.\n"
                                      "\n Please try again."),
                                )
                            )
                        );
                      });
                  return;
                }
                MeetupsController.fetchMeetups(context);
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
