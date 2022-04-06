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
          Image.asset(
            "assets/app_icon.png",
            height: 150,
          ),
          const SizedBox(height: 25),
          const Text("Welcome to Aura!", style: TextStyle(fontSize: 32),),
          const SizedBox(height: 25),
          Center(
            child: OutlinedButton(
              onPressed: () {
                signInWithGoogle().then((value) => {context.go("/tabs/map")});
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.login,
                      size: 24,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ]),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.redAccent,
                fixedSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ]));
  }
}
