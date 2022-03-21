import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'threadTopicDropDown.dart';

void main() => runApp(createThread());

class createThread extends StatefulWidget {
  const createThread({Key? key}) : super(key: key);

  @override
  _createThreadState createState() => _createThreadState();
}

class _createThreadState extends State<createThread> {
  final titleController = TextEditingController(); //Saves edited title
  final contentController = TextEditingController(); //Saves edited content
  final dropdownMenu = dropDownMenu();

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
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5), child: titleField()),
              Padding(padding: EdgeInsets.all(5), child: dropdownMenu),
              Padding(padding: EdgeInsets.all(5), child: contentField()),
              Padding(padding: EdgeInsets.all(5), child: submitButton(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() => TextFormField(
    // onChanged: (value) => setState(() => this.title = value), //og.title = value
    controller: titleController,
    decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter the title of your post here", border: OutlineInputBorder()),
    keyboardType: TextInputType.multiline,
    textInputAction: TextInputAction.next,
  );

  Widget contentField() => TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
    controller: contentController,
    decoration: InputDecoration(
        labelText: "Content",
        hintText: "Enter the content of your post here", border: OutlineInputBorder()),
  );

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      child: Text("Submit"),
      onPressed: () {
        setState(() {
          String a = dropdownMenu.dr
          //Create thread
          /*thread_manager.addThread(
            titleController.text,
            contentController.text,


          );*/
          Navigator.pop(context); //Return to previous, but updated threadlistview*/
        });
      },
    );
  }
}
