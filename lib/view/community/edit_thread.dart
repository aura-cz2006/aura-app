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
  String threadID = "1";
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => Thread_Manager()),
      //ChangeNotifierProvider(create: (context) => User_Manager()),
    ], child: EditThreadView(threadID: threadID)),
  );
}

class EditThreadView extends StatefulWidget {
  final String threadID;

  EditThreadView({required this.threadID});

  @override
  _EditThreadViewState createState() => _EditThreadViewState();
}

class _EditThreadViewState extends State<EditThreadView> {
  var titleController = TextEditingController(); //Saves edited title
  var contentController = TextEditingController(); //Saves edited content

  TextEditingController _initTitleController(String og_title) {
    titleController.text = og_title;
    return titleController;
  }

  TextEditingController _initContentController(String og_content) {
    contentController.text = og_content;
    return contentController;
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
              Padding(padding: EdgeInsets.all(5), child: submitButton(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Consumer<Thread_Manager>(builder: (context, threadMgr, child) {
      return TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: _initTitleController(
            threadMgr.getThreadByID(widget.threadID)!.title!),
        decoration: InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of your post here",
            border: OutlineInputBorder()),
        textInputAction: TextInputAction.next,
      ); // move whatever was built in Widget build here
    });
  }

  Widget contentField() {
    return Consumer<Thread_Manager>(builder: (context, threadMgr, child) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        controller: _initContentController(
            threadMgr.getThreadByID(widget.threadID)!.content),
        decoration: const InputDecoration(
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
        textInputAction: TextInputAction.done,
      );
    });
  }

  Widget submitButton(BuildContext context) {
    return Consumer<Thread_Manager>(builder: (context, thread_manager, child) {
      return ElevatedButton(
        child: Text("Submit"),
        onPressed: () {
          setState(() {
            print("Text: ${titleController.text}, Content: ${contentController.text}"); // TODO REMOVE
            thread_manager.editThread(
                //Update thread
                widget.threadID,
                titleController.text,
                contentController.text);
            context.pop(); // Navigator.pop(context); //Return to previous, but updated thread
          });
        },
      );
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
