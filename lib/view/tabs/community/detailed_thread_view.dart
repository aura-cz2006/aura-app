import 'package:aura/models/thread.dart';
import 'package:flutter/material.dart';


class DetailedThreadView extends StatelessWidget {
  final Thread thread;

  const DetailedThreadView(this.thread);
  // const DetailedThreadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text('Discussion Thread'),
      ),
      body: Center( // TODO: implement detailed thread view
        child: Text("Detailed Thread View for "
            "${thread.title ?? ""} (id: ${thread.id ?? ""})"),

      ),
    );
  }
}