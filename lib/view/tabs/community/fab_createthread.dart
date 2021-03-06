import 'package:aura/models/discussion_topic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FAB_CreateThread extends StatefulWidget {
  final DiscussionTopic topic;
  const FAB_CreateThread({Key? key, required this.topic}) : super(key: key);

  @override
  _FAB_CreateThreadState createState() => _FAB_CreateThreadState();
}

class _FAB_CreateThreadState extends State<FAB_CreateThread> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50, right: 20),
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          context.push("${GoRouter.of(context).location}/createThread");
          setState(() {
          });
        },
      ),
    );
  }
}

//
// class FAB_CreateThread extends StatelessWidget {
//   final DiscussionTopic topic;
//
//   const FAB_CreateThread({Key? key, required this.topic}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 50, right: 20),
//       child: FloatingActionButton(
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.lightBlueAccent,
//         onPressed: () {
//           context.push("${GoRouter.of(context).location}/createThread");
//
//         },
//       ),
//     );
//   }
// }