import 'package:flutter/material.dart';

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
            _currentaddressfield()
          ]
      )
    )
    );
  }
}


Widget _currentaddressfield() {
  return Container(
    child: TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: "current_address",
      ),
    )
  );
}

