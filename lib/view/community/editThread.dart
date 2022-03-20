import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/thread.dart';



void main() => runApp(_createPost());

class _createPost extends StatefulWidget {

  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<_createPost> {
  final titleController = TextEditingController(text: "Sports"); //Access original thread's title
  final contentController = TextEditingController(text: "I love basketball"); //Access original thread's content

  String title = "";
  String content = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(5), child: titleField()),
                Padding(padding: EdgeInsets.all(5), child: contentField()),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: submitButton())
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
    textInputAction: TextInputAction.next,
  );

  Widget contentField() => TextFormField(
    // onChanged: (value) => setState(() => this.content = value),
    onFieldSubmitted: (value) => setState(() => this.content = value),
    keyboardType: TextInputType.multiline,
    controller: contentController,
    decoration: InputDecoration(
        labelText: "Content",
        hintText: "Enter the content of your post here", border: OutlineInputBorder()),
    textInputAction: TextInputAction.done,
  );

  Widget submitButton(){
    return ElevatedButton(
      child: Text("Submit"),
      onPressed: () {
        print('Title: ${titleController.text}\nContent: ${contentController.text}');

      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
