import 'package:flutter/material.dart';
import 'package:aura/settingpage.dart';

void main()=> runApp(HomeAddresspage());

class HomeAddresspage extends StatelessWidget {

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('Change Home Address')
          ),
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _currentaddressfield(),
            ),
            Divider(color: Colors.black),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _homeaddressfield(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _confirmationdialog(),
            ),
          ]
      )
    )
    );
  }
}


Widget _currentaddressfield() {
  return Container(
    child: Text("Current Address:\n62 Nanyang Drive",
        style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 30
        )
      )
    );
}

Widget _homeaddressfield() {
  return Container(
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "Enter your new home address",
        ),
      )
  );
}

Widget _confirmationdialog(){
  return Container(
    child: ElevatedButton(
        child: Text('Confirm'),
  onPressed: () {
      /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
      );*/
      // do something
      },
    )
  );
}