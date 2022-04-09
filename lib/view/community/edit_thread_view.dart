import 'dart:core';
import 'package:aura/controllers/thread_controller.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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

  const EditThreadView({Key? key, required this.threadID}) : super(key: key);

  @override
  _EditThreadViewState createState() => _EditThreadViewState();
}

class _EditThreadViewState extends State<EditThreadView> {
  var titleController = TextEditingController(); //Saves edited title
  var contentController = TextEditingController(); //Saves edited content
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //For validation of user input

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
          appBar: AuraAppBar(
            title: const Text('Edit Thread'),
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5), child: titleField()),
                  Padding(
                      padding: const EdgeInsets.all(5), child: contentField()),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: submitButton(context))
                ],
              ),
            ),
          )),
    );
  }

  Widget titleField() {
    return Consumer<Thread_Manager>(builder: (context, threadMgr, child) {
      return TextFormField(
        // onChanged: (value) => setState(() => this.title = value), //og.title = value
        controller: _initTitleController(
            threadMgr.getThreadByID(widget.threadID)!.title!),
        decoration: const InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of your post here",
            border: OutlineInputBorder()),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isNotEmpty) {
            return null;
          } else {
            return "Please enter a title.";
          }
        },
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
        validator: (value) {
          if (value!.isNotEmpty) {
            return null;
          } else {
            return "Please enter the contents of your post.";
          }
        },
      );
    });
  }

  Widget submitButton(BuildContext context) {
    return Consumer<Thread_Manager>(builder: (context, thread_manager, child) {
      return ElevatedButton(
        child: const Text("Submit"),
        onPressed: () {
          setState(() async {
            //Validation for empty fields. CANNOT SUBMIT IF EMPTY
            if (!_formKey.currentState!.validate()) {
              return;
            }

            await ThreadController.patchThread(
                //Update thread
                thread: thread_manager.getThreadByID(widget.threadID)!,
                title: titleController.text,
                content: contentController.text).then((statcode) {
                  if (statcode == 200){
                    setState(() async {
                      await ThreadController.fetchThreads(
                          context);
                      print("Patch Thread Success!");
                      context.pop();
                    });
                  }

                  if (statcode !=200){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              elevation: 10,
                              scrollable: true,
                              content: Center(
                                  child: Container(
                                    child: const Text("Unable to create thread.\n"
                                        "\n Please try again."),
                                  )));
                        });
                  }
            });
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
