import 'package:flutter/material.dart';
import 'createthread.dart';

void main()=> runApp(FAB());

class FAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title: Center(
                  child: Text('FAB')
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              )
          ),
          floatingActionButton: _FAB(),
        )
    );
  }
}

Widget _FAB(){
  return Padding(
    padding: EdgeInsets.only(bottom: 50, right: 20),
    child: fabWidget(),
  );
}

class fabWidget extends StatefulWidget {
  fabWidget();

  @override
  _fabWidgetState createState() => _fabWidgetState();
}

class _fabWidgetState extends State<fabWidget>{
  var _isSelected = false;

  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.mode_edit_sharp),
      backgroundColor: Colors.lightBlueAccent,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => createThread()),
        );
      },
    );
  }
}