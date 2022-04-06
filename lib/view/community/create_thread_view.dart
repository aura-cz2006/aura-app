import 'package:aura/apis/discussion_api.dart';
import 'package:aura/controllers/thread_controller.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AuraAppBar(
          title: const Text('Create Thread'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              children: [
                Padding(padding: EdgeInsets.all(5), child: titleField()),
                Padding(padding: EdgeInsets.all(5), child: contentField()),
                Padding(padding: EdgeInsets.all(5), child: submitButton(context))
              ],
            ),
          ),
        )
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
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter a title.";
          }
        },
      );

  Widget contentField() => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: contentController,
        minLines: 10,
        decoration: const InputDecoration(
          contentPadding:  EdgeInsets.all(5),
            labelText: "Content",
            hintText: "Enter the content of your post here",
            border: OutlineInputBorder()),
        validator: (value){
          if (value!.isNotEmpty){
            return null;
          } else {
            return "Please enter the contents of your post.";
          }
        },
      );

  Widget submitButton(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 100,
        height: 50,
        child: Card(child: Consumer2<Thread_Manager, User_Manager>(
            builder: (context, threadCtrl, userMgr, child) {
          return ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              setState(() async {
                if (!_formKey.currentState!.validate()){
                  return;
                }
                //Create thread
                int response = await ThreadController.createThread(
                    title : titleController.text,
                    content : contentController.text,
                    topic: widget.topic,
                    userID: userMgr.active_user_id //Not yet available
                    );
                if (response == 200) {print("Posting Thread Success");}

                //Failure Message
                if (response == 400){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            elevation: 10,
                            scrollable: true,
                            content: Center(
                                child: Container(
                                  child: Text("Unable to create thread.\n"
                                      "\n Please try again."),
                                )
                            )
                        );
                      });
                  return;
                }
                ThreadController.fetchThreads(context);

                context.pop();
              });
            },
          );
        })),
      ),
    );
  }
}
