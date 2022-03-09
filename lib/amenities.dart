import 'package:flutter/material.dart';

void main()=> runApp(Settings());

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Center(
                    child: Text('Settings')
                ),
                automaticallyImplyLeading: true,
                leading: IconButton(icon: Icon(Icons.arrow_back),
                  onPressed:() => Navigator.pop(context, false),
                )
            ),
            body: Container(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    rowChips(),
                  ],
                )
              ),
        )
    );
  }
}

Widget rowChips(){
  return Row(
    children: <Widget>[
      _amenitychip("Hairdresser", Color(0xFFff8a65)),
      _amenitychip("ATM", Color(0xAB128a65)),
      _amenitychip("Hairdresser", Color(0xFFAf8a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("Healthcare", Color(0xffffbf04)),
      _amenitychip("Policea", Color(0xFF4343FC)),
      _amenitychip("Banks", Color(0xFF418a65)),
      _amenitychip("Hairdresser", Color(0xFFAf8a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("Hairdresser", Color(0xFFAf8a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("Hairdresser", Color(0xFFAf8a65)),
      _amenitychip("Bank", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),
      _amenitychip("CC", Color(0xFF418a65)),

    ],
  );
}

Widget _amenitychip(String text, Color colour) {
  return Container(
    margin: EdgeInsets.all(6.0), //Spacing in between chips
      child: ChoiceChip(
      selected: false,
      label: Text(text), //text
      labelStyle: TextStyle(color: Colors.black), //text colour
      backgroundColor: colour, //unselected color
      selectedColor: Colors.blue, //selected color
      elevation: 1.0,
      onSelected: (bool selected) {
      }
    )
  );
}
