import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AuraAppBar(
              title: const Text('Settings'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _changeHomeAddressButton(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _logoutButton(context),
                  ),
                ],
              ),
            )));
  }

  Widget _changeHomeAddressButton(BuildContext context) {
    return ElevatedButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(
          Icons.home,
          size: 30,
        ),
        SizedBox(width: 16),
        Text(
          "Change Home Address",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ]),
      onPressed: () {
        GoRouter.of(context).push("/settings/change_home_address");
        // context.go('${GoRouter.of(context).location}/change_home_address');
      },
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.white,
        side: const BorderSide(color: Colors.black, width: 2),
        fixedSize: const Size(300, 70),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(
          Icons.logout,
          size: 30,
        ),
        SizedBox(width: 16),
        Text(
          "Log Out",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ]),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.redAccent,
        fixedSize: const Size(300, 70),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
