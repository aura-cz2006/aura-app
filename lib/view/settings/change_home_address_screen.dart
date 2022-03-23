import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';


class ChangeHomeAddressScreen extends StatefulWidget {
  final String threadID;

  EditThreadView({required this.threadID});

  @override
  _ChangeHomeAddressScreenState createState() => _ChangeHomeAddressScreenState();
}

class _ChangeHomeAddressScreenState extends State<ChangeHomeAddressScreen> {
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

  Widget originalAddressField() {
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

