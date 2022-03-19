import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';

class ChangeHomeAddressScreen extends StatelessWidget {
  const ChangeHomeAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Center(child: Text('Change Home Address')),
                automaticallyImplyLeading: true,
                leading: const AppBarBackButton()),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _currentAddressField(),
                  ),
                  const Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _homeAddressField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _confirmationDialog(),
                  ),
                ])));
  }
}

Widget _currentAddressField() {
  return const Text("Current Address:\n62 Nanyang Drive",
      style: TextStyle(color: Colors.deepOrange, fontSize: 30));
}

Widget _homeAddressField() {
  return TextFormField(
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: "Enter your new home address",
    ),
  );
}

Widget _confirmationDialog() {
  return ElevatedButton(
    child: const Text('Confirm'),
    onPressed: () {
      /*Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Settings()),
  );*/
      // do something
    },
  );
}
