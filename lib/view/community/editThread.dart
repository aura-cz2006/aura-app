import 'dart:core';
import 'package:aura/managers/thread_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/models/comment.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';


void main() {
  User user = User("USER_ID", "USERNAME");
  Thread test = Thread("TEST_ID", "This is the Title.", user,
    "This is the thread content.", DateTime.now());

  runApp(editThread(og_thread: test,));
}

class editThread extends StatefulWidget {
  Thread og_thread;

  editThread({required this.og_thread});

  @override
  _editThreadState createState() => _editThreadState();
}

class _editThreadState extends State<editThread> {
  late String title = widget.og_thread.title ?? '';
  late String content = widget.og_thread.content;
  final titleController = TextEditingController(); //Saves edited title
  final contentController = TextEditingController(); //Saves edited content

  @override
  void initState(){
    super.initState();
    titleController.text = title; //Prefill title with original thread title
    contentController.text = content; //Prefill content with original content title
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(child: Text('Edit Thread')),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(5), child: titleField()),
                Padding(padding: EdgeInsets.all(5), child: contentField()),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: submitButton(context))
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
    keyboardType: TextInputType.multiline,
    maxLines: null,
    controller: contentController,
    decoration: InputDecoration(
        labelText: "Content",
        hintText: "Enter the content of your post here", border: OutlineInputBorder()),
  );

  Widget submitButton(BuildContext context){
    return ElevatedButton(
      child: Text("Submit"),
      onPressed: () {
        setState(() {
          /*thread_manager.editThreadFunction( //Update thread
              "Nature", //Later discuss with Ryan/Nicole
              widget.og_thread.id,
              titleController.text,
              contentController.text
          );
          Navigator.pop(context); //Return to previous, but updated thread*/
        });
      },
    );
    // return Consumer<Thread_Manager>(builder: (context, thread_manager, child){
    //   return ElevatedButton(
    //         child: Text("Submit"),
    //         onPressed: () {
    //           setState(() {
    //             thread_manager.editThreadFunction( //Update thread
    //               "Nature", //Later discuss with Ryan/Nicole
    //               widget.og_thread.id,
    //               titleController.text,
    //               contentController.text
    //             );
    //             Navigator.pop(context); //Return to previous, but updated thread
    //           });
    //         },
    //       );
    // });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
