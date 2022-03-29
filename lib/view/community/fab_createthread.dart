import 'package:aura/models/discussion_topic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateThreadFAB extends StatefulWidget {
  final DiscussionTopic topic;

  const CreateThreadFAB({Key? key, required this.topic});

  @override
  _CreateThreadFABState createState() => _CreateThreadFABState();
}

class _CreateThreadFABState extends State<CreateThreadFAB> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 50, right: 20),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            context.push("${GoRouter.of(context).location}/createThread");
          },
        ));
  }
}
