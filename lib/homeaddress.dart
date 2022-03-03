import 'package:flutter/material.dart';

void main()=> runApp(HomeAddresspage());

class HomeAddresspage extends StatelessWidget {
  HomeAddresspage({required this.current_address});
  String current_address;

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
            TextFormField(
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
              ),
            ),

          ]

      )
    )
  }
}


Widget _currentaddressfield() {

}

