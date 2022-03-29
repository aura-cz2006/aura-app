import 'package:flutter/material.dart';
import 'package:aura/view/community/create_meetup_view.dart';
import 'package:go_router/go_router.dart';

class CreateMeetupFAB extends StatefulWidget {
  const CreateMeetupFAB({Key? key}) : super(key: key);

  @override
  _CreateMeetupFABState createState() => _CreateMeetupFABState();
}

class _CreateMeetupFABState extends State<CreateMeetupFAB> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 50, right: 20),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            context.push("${GoRouter.of(context).location}/createMeetup");
          },
        ));
  }
}
