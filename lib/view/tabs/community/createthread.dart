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
  String topic = '';

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
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(5), child: titleField()),
              Padding(padding: EdgeInsets.all(5),
                  child: new dropDownMenu(topic: (String val) => setState(() => topic = val))),
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
    return Align(
      child: SizedBox(
        width: 100,
        height: 50,
        child: Card(
          child: ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              setState(() {
                print(Text("Title: ${titleController.text}\nTopic: ${topic}\nContent: ${contentController.text}"));
                //Create thread
                /*thread_manager.addThread(
            titleController.text,
            contentController.text,
            topic,
            userManager.userID //Not yet available
          );*/
                // Navigator.pop(context); //Return to previous, but updated threadlistview*/
              });
            },
          ),
        ),
      ),
    );
  }
}