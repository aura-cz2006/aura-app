import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FAB_CreateMeetupView extends StatelessWidget {
  const FAB_CreateMeetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50, right: 20),
      child: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          context.push("${GoRouter.of(context).location}/createMeetup");
        },
      ),
    );
  }
}