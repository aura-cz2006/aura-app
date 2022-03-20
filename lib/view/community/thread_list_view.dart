import 'package:aura/models/user.dart';
import 'package:intl/intl.dart';

import 'package:aura/managers/thread_manager.dart';
import 'package:flutter/material.dart';

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
  User curr_user = User('1', 'Ryan');

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
            children: (active_thread_manager.getListOfThreadsSortedByTime(topic))
                .map((t) => ListTile(
                      title: Text(t.title ?? "Untitled thread"),
                      onTap: null,
                      subtitle: Text(t.content),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          Text(DateFormat('yyyy-MM-dd kk:mm')
                          .format(t.timestamp)),
                          Text('${t.numLikes()}'),
                          // TODO: add date time properly into thread.dart
                          Icon(Icons.thumb_up_alt_outlined),
                          // icon-2
                        ],
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
