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
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1, color: Colors.white),
            ),
            onPressed: () {
              context.go("/tabs/map");
            },
            child: Image.network(
                'https://www.gstvoucher.gov.sg/app/Content/images/LoginWithSingpass.png'),
          ),
        ]));
  }
}
