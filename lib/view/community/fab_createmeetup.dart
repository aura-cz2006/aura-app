import 'package:flutter/material.dart';
import 'package:aura/view/community/create_meetup_view.dart';
import 'package:go_router/go_router.dart';

//void main() => runApp(FAB());

// class FAB extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//           title: Center(child: Text('FAB')),
//           automaticallyImplyLeading: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context, false),
//           )),
//       floatingActionButton: FAB_CreateMeetupView(),
//     ));
//   }
// }

Widget FAB_CreateMeetupView() {
  return Padding(
    padding: EdgeInsets.only(bottom: 50, right: 20),
    child: fabWidget(),
  );
}

class fabWidget extends StatefulWidget {
  fabWidget();

  @override
  _fabWidgetState createState() => _fabWidgetState();
}

class _fabWidgetState extends State<fabWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.lightBlueAccent,
      onPressed: () {
        context.push("${GoRouter.of(context).location}/createMeetup");
      },
    );
  }
}
