import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void main() => runApp(myApp());
//
// class myApp extends StatefulWidget {
//   const myApp({Key? key}) : super(key: key);
//
//   @override
//   _myAppState createState() => _myAppState();
// }
//
// class _myAppState extends State<myApp> {
//   DateTime user_input = DateTime.now(); // .add(Duration(days: 4));
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: new datetime_picker(
//               date_reference:  user_input,
//               onClicked: (DateTime val) => setState(() => user_input = val)
//           ),
//         ),
//       ),
//     );
//   }
// }

typedef void DateTimeCallback(DateTime val);

class datetime_picker extends StatefulWidget {
  final DateTimeCallback onClicked;
  final DateTime date_reference; //For editting purposes

  const datetime_picker(
      {Key? key, required this.onClicked, required this.date_reference})
      : super(key: key);

  @override
  _datetime_pickerState createState() => _datetime_pickerState();
}

class _datetime_pickerState extends State<datetime_picker> {
  final formatter = DateFormat('dd-MM-yyyy HH:mm');
  DateTime date = DateTime(0000);
  TimeOfDay initialTime = TimeOfDay.now();

  @override
  void initState() {
    date = widget.date_reference;
  }

  String getDate() {
    if (date.isBefore(DateTime.now())) {
      /*
      * For Editting: the date reference is always ahead
      * For creating: the date reference is always behind
      * */
      return "Select Date and Time";
    } else {
      //Display chosen or previously chosen date/time
      return formatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlueAccent,
        ),
        onPressed: () => Pick_DateTime(context),
        child: Text(getDate(), style: TextStyle(color: Colors.black)),
      );

  Future Pick_DateTime(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate:
            initialDate, //When calender opens, today will be highlighted
        firstDate: DateTime(DateTime.now()
            .year), //Available date range from this year to next year
        lastDate: DateTime(DateTime.now().year + 2));
    //If User cancel instead of picking date
    if (newDate == null) return;

    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
    //If User cancel instead of picking time
    if (newTime == null) return;

    setState(() {
      date = newDate;
      initialTime = newTime;
      date = DateTimeField.combine(date, initialTime);
      widget.onClicked(date);
    });
  }
}