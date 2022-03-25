import 'package:aura/models/discussion_topic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// class FAB extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           appBar: AppBar(
//               title: Center(
//                   child: Text('FAB')
//               ),
//               automaticallyImplyLeading: true,
//               leading: IconButton(icon: Icon(Icons.arrow_back),
//                 onPressed:() => Navigator.pop(context, false),
//               )
//           ),
//           floatingActionButton: FAB_CreateThread(),
//         )
//     );
//   }
// }

Widget FAB_CreateThread(DiscussionTopic topic){
  return Padding(
    padding: EdgeInsets.only(bottom: 50, right: 20),
    child: fabWidget(topic: topic),
  );
}

class fabWidget extends StatefulWidget {
  final DiscussionTopic topic;

  const fabWidget({Key? key, required this.topic});

  @override
  _fabWidgetState createState() => _fabWidgetState();
}

class _fabWidgetState extends State<fabWidget>{

  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.lightBlueAccent,
      onPressed: () {
        context.push("${GoRouter.of(context).location}/createThread");
      },
    );
  }
}