import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class dropDownMenu extends StatefulWidget {
  final StringCallback topic;

  const dropDownMenu({required this.topic});

  @override
  _dropDownMenuState createState() => _dropDownMenuState();
}

class _dropDownMenuState extends State<dropDownMenu> {
  //Default dropdown item
  String dropdownValue = "Nature";

  //Get topic value
  String getTopic() => dropdownValue;

  //List of Topics
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Nature"),value: "Nature"),
      DropdownMenuItem(child: Text("Food"),value: "Food"),
      DropdownMenuItem(child: Text("General"),value: "General"),
      DropdownMenuItem(child: Text("IT"),value: "IT"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Text("Topic:", style: TextStyle(fontSize: 20, color: Colors.black),),
        ),
        Padding(
          padding: EdgeInsets.only(left:5),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: 200),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(20),
                )
            ),
            value: dropdownValue,
            style: TextStyle(color: Colors.black, fontSize: 20),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            iconSize: 20,
            items: dropdownItems,
            onChanged: (String? newValue){
              setState(() {
                dropdownValue = newValue!;
                widget.topic.call(getTopic());
              });
            },
          )
        ),
      ],
    );
  }
}
