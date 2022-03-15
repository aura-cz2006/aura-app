import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              submitButton(),
            ],
          ),
        )
    );
  }
}

Widget _contentbox() {
  return Expanded(
      child: SingleChildScrollView(
          child:Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x11111111),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Content of Thread",
                    )
                ),
              )
            )
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

Widget submitButton() {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
              )
          )
      ),
      child: Text("Submit"),
      onPressed: (){
        /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => createThread()),*/
      },
    ),
  );
}
