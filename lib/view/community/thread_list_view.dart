import 'package:provider/provider.dart';

import 'package:aura/managers/thread_manager.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

void main() => runApp(ThreadListView());

class ThreadListView extends StatefulWidget {
  const ThreadListView({Key? key}) : super(key: key);

  @override
  State<ThreadListView> createState() => _ThreadListViewState();
}

class _ThreadListViewState extends State<ThreadListView> {
  var topic =
      'Nature'; //TODO: Frontend view before this page has to pass a topic to this view to render
  Thread_Manager active_thread_manager = Thread_Manager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text("Specific topic"),
        ),
        body: ListView(
            children: (active_thread_manager.threadMap[topic] ?? [])
                .map((t) => ListTile(
                      title: Text(t.title ?? "Untitled thread"),
                      onTap: null,
                      subtitle: Text(t.content),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          Text("11/11/22"),
                          // TODO: add date time properly into thread.dart
                          Icon(Icons.thumb_up_outlined),
                          // icon-2
                        ],
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
