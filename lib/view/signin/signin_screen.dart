import 'package:aura/util/sign_in_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          OutlinedButton(
            onPressed: () {
              signInWithGoogle().then((value) => {context.go("/tabs/map")});
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ]),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.black,
              fixedSize: const Size(300, 70),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        ]));
  }
}
