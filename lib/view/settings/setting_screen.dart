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
                    padding: EdgeInsets.only(top: 10),
                    child: ChangeHomeButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _logoutButton(),
                  ),
                ],
              ),
            )));
  }
}

Widget _logoutButton() {
  return ElevatedButton(
    onPressed: () {
/*        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Signin()), //TODO: Jamie's sign in screen goes here
      );*/
    },
    child: const Text('Logout'),
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      //Background color
      onPrimary: Colors.black,
      //Text
      fixedSize: const Size(240, 50),
      padding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    ),
  );
}

class ChangeHomeButton extends StatelessWidget {
  const ChangeHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('${GoRouter.of(context).location}/change_home_address');
      },
      child: const Text('Change Home Address'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        //Background color
        onPrimary: Colors.black,
        //Text
        fixedSize: const Size(240, 50),
        padding: const EdgeInsets.all(25),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
