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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _changehomeButton(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: _logoutButton(),
                ),
              ],
            ),
          )
        )
    );
  }
}

Widget _logoutButton() {
  return Container(
    child: ElevatedButton(
      onPressed: () {},
      child: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, //Background color
        onPrimary: Colors.black, //Text
        fixedSize: const Size(240,50),
        padding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    ),
  );
}

Widget _changehomeButton() {
  return Container(
    child: ElevatedButton(
      onPressed: () {},
      child: const Text('Change Home Address'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, //Background color
        onPrimary: Colors.black, //Text
        fixedSize: const Size(240,50),
        padding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    ),
  );
}