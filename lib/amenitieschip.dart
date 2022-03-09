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
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        rowChips(),
                      ],
                    )
                ),
              ),
            )
        )
    );
  }
}

Widget rowChips(){
  return Row(
    children: <Widget>[
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
      _amenitychip("ABCDFEFEFASD", 0xFFff8a65),
    ],
  );
}

Widget _amenitychip(String text, int colour) { //Controls spacing between chips
  return Container(
      margin: EdgeInsets.all(2.0), //Spacing in between chips
      child: amenityChipWidget(chipName: text, bgColour: colour)
  );
}

// class AmenityChipDisplay extends StatefulWidget {
//   @override
//   _AmenityChipDisplayState createState() => _AmenityChipDisplayState();
// }

class amenityChipWidget extends StatefulWidget {
  final String chipName;
  final int bgColour;

  amenityChipWidget({required this.chipName, required this.bgColour});

  @override
  _amenityChipWidgetState createState() => _amenityChipWidgetState();
}

class _amenityChipWidgetState extends State<amenityChipWidget>{
  var _isSelected = false;

  @override
  Widget build(BuildContext context){
    return ChoiceChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(color: Colors.black),
      selected: _isSelected,
      elevation: 1.0,
      backgroundColor: Color(0xffffffff),
      onSelected: (isSelected){
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Color(widget.bgColour),
    );
  }
}