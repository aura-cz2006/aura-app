import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Center(child: Text('Settings')),
                automaticallyImplyLeading: true,
                leading: const AppBarBackButton()),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ChangeHomeButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _logoutButton(),
                  ),
                ],
              ),
            )));
  }
}

Widget _logoutButton(){
  return ElevatedButton(
      onPressed: (){},
      child: Text("Log Out"),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white, //text
        primary: Colors.blue,
        fixedSize: Size(240,50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      )
  );
}



class ChangeHomeButton extends StatelessWidget {
  const ChangeHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Change Home Address"),
      onPressed: (){
        GoRouter.of(context).push("/settings/change_home_address");
        // context.go('${GoRouter.of(context).location}/change_home_address');
      },
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white, //text
        primary: Colors.blue,
        fixedSize: Size(240,50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      )
    );
  }
}

