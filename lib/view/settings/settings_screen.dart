import 'dart:developer';

import 'package:aura/widgets/aura_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const SettingsScreen());

void printFirebaseIdToken() async {
  var token = await FirebaseAuth.instance.currentUser?.getIdToken();
  print("++++++ firebase token ++++++++");
  log(token ?? "");
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    printFirebaseIdToken();

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
                    child: _currentUser(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _changeHomeAddressButton(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _logoutButton(context),
                  ),
                ],
              ),
            )));
  }

  Widget _currentUser(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data as User?;
          if (user != null) {
            // if user is signed in
            return Column(children: [
              ClipOval(
                  child: SizedBox.fromSize(
                      size: const Size.fromRadius(75), // Image radius
                      child: Image.network(
                        user.photoURL ?? "",
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ))),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    user.displayName ?? "no name",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  )),
              Text(user.email ?? "no email")
            ]);
          } else {
            // if user isn't signed in
            // ! the user shouldn't be able to access this !!!!

            return const Text("No user!");
          }
        });
  }

  Widget _changeHomeAddressButton(BuildContext context) {
    return ElevatedButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(
          Icons.home,
          size: 24,
        ),
        SizedBox(width: 16),
        Text(
          "Change Home Address",
          style: TextStyle(fontSize: 16, color: Colors.black),
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
        fixedSize: const Size(250, 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance
            .signOut()
            .then((value) => {context.go("/sign-in")});
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(
          Icons.logout,
          size: 24,
        ),
        SizedBox(width: 16),
        Text(
          "Sign Out",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ]),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.redAccent,
        fixedSize: const Size(250, 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
