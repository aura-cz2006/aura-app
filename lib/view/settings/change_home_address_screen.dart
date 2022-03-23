import 'package:aura/managers/user_manager.dart';
import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ChangeHomeAddressScreen extends StatefulWidget {

  ChangeHomeAddressScreen();

  @override
  _ChangeHomeAddressScreenState createState() => _ChangeHomeAddressScreenState();
}

class _ChangeHomeAddressScreenState extends State<ChangeHomeAddressScreen> {
  var oldaddressController = TextEditingController(); //Saves
  var newaddressController = TextEditingController();// s edited content

  TextEditingController _initAddressController(String og_title) {
    oldaddressController.text = og_title;
    return oldaddressController;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Center(child: Text('Change Home Address')),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20, left: 5, right: 5,bottom: 5), child: originalAddressField()),
              Padding(padding: EdgeInsets.all(5), child: newAddressField()),
              Padding(padding: EdgeInsets.all(5), child: submitButton(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget originalAddressField() {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return TextFormField(
        readOnly: true,
        maxLines: null,
        controller: _initAddressController(
            userMgr.getUser(userMgr.active_user_id)!.getHomeAddress()),
        decoration: InputDecoration(
            labelText: "Original Address",
            border: OutlineInputBorder()),
      );
    });
  }

  Widget newAddressField() {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: newaddressController,
        decoration: InputDecoration(
            labelText: "New Address",
            border: OutlineInputBorder()),
      );
    });
  }

  Widget submitButton(BuildContext context) {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return ElevatedButton(
        child: Text("Submit"),
        onPressed: () {
          setState(() {
            print("New Home Address: ${newaddressController.text}"); // TODO REMOVE
            userMgr.updateHomeAddress( //update User's homeaddress in manager
              userMgr.active_user_id,
              newaddressController.text
            );
            context.pop(); // Navigator.pop(context); //Return to previous, but updated thread
          });
        },
      );
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    oldaddressController.dispose();
    super.dispose();
  }
}

