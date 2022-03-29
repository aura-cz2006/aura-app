import 'package:aura/managers/thread_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(const CreateThreadView(topic: DiscussionTopic.NATURE));

class CreateThreadView extends StatefulWidget {
  final DiscussionTopic topic;

  const CreateThreadView({Key? key, required this.topic}) : super(key: key);

  @override
  _CreateThreadViewState createState() => _CreateThreadViewState();
}

class _CreateThreadViewState extends State<CreateThreadView> {
  final titleController = TextEditingController(); //Saves edited title
  final contentController = TextEditingController(); //Saves edited content

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AuraAppBar(
          title: const Text('Create Thread'),
        ),
        body: Center(
          child: ListView(
            children: [
              Padding(padding: const EdgeInsets.all(5), child: titleField()),
              Padding(padding: const EdgeInsets.all(5), child: contentField()),
              Padding(
                  padding: const EdgeInsets.all(5),
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
        decoration: const InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of your post here",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.next,
      );

  Widget contentField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: contentController,
        decoration: const InputDecoration(
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
      );

  Widget submitButton(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 100,
        height: 50,
        child: Card(child: Consumer2<Thread_Manager, User_Manager>(
            builder: (context, threadMgr, userMgr, child) {
          return ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              setState(() {
                // print(Text(
                //     "Title: ${titleController.text} \nTopic: ${widget.topic.topic2readable()} \nContent: ${contentController.text}"));
                //Create thread
                threadMgr.addThread(
                    titleController.text,
                    contentController.text,
                    widget.topic,
                    userMgr.active_user_id //Not yet available
                    );
                context.pop();
              });
            },
          );
        })),
      ),
    );
  }
}
