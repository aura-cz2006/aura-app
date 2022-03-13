import 'package:flutter/material.dart';
import '../../models/meetup.dart';

class DetailedMeetupView extends StatelessWidget {
  final Meetup meetup;

  const DetailedMeetupView(this.meetup);
  // const DetailedThreadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text('Meetup'),
      ),
      body: Center( // TODO: implement detailed meetup view
        child: Text("Detailed Meetup View for "
            "${meetup.title ?? ""} (id: ${meetup.id ?? ""})"),

      ),
    );
  }
}