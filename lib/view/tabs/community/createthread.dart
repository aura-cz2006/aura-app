import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main()=> runApp(createThread());

class createThread extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title: Center(
                  child: Text('Create Thread')
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              )
          ),
          body: Column(
            children: <Widget>[
              _titlebox(),
              _contentbox(),
            ],
          ),
        )
    );
  }
}

Widget _contentbox() {
  return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x11111111),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Content of Thread",
              )
          ),
        )
      )
  );
}

Widget _titlebox() {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        color: Color(0x11111111),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: TextFormField(
          decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Title of thread',
          )
        ),
      )
    )
  );
}