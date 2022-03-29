import 'package:aura/managers/user_manager.dart';
import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ChangeHomeAddressScreen extends StatefulWidget {
  const ChangeHomeAddressScreen({Key? key}) : super(key: key);

  @override
  _ChangeHomeAddressScreenState createState() =>
      _ChangeHomeAddressScreenState();
}

class _ChangeHomeAddressScreenState extends State<ChangeHomeAddressScreen> {
  var oldaddressController = TextEditingController(); //Saves
  var newaddressController = TextEditingController(); // s edited content
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _initAddressController(String og_title) {
    oldaddressController.text = og_title;
    return oldaddressController;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AuraAppBar(title: const Text('Edit Home Address')),
        body: Center(
          child: Column(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 5),
                  child: originalAddressField()),
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
              labelText: "Original Address", border: OutlineInputBorder()),
        );
    });
  }

  Widget newAddressField() {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return Form(
        key: _formKey,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: newaddressController,
          decoration: InputDecoration(
              labelText: "New Address", border: OutlineInputBorder()),
          validator: (value){
            if (value!.isNotEmpty){
              return null;
            } else {
              return "Please enter an address.";
            }
          },
      ));
    });
  }

  Widget submitButton(BuildContext context) {
    return Consumer<User_Manager>(builder: (context, userMgr, child) {
      return ElevatedButton(
        child: Text("Submit"),
        onPressed: () {
          setState(() {
            if (!_formKey.currentState!.validate()){
              return;
            }
            userMgr.updateHomeAddress(
                //update User's homeaddress in manager
                userMgr.active_user_id,
                newaddressController.text);
            context
                .pop(); // Navigator.pop(context); //Return to previous, but updated thread
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
