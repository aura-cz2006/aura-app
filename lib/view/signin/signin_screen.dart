import 'package:aura/managers/user_manager.dart';
import 'package:aura/util/sign_in_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text("Signing in...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
                  SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                        strokeWidth: 5,
                      )),
                ],
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Image.asset(
                      "assets/app_icon.png",
                      height: 150,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Welcome to Aura!",
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Consumer<User_Manager>(builder: (context, userMgr, child) {
                        return OutlinedButton(
                          onPressed: () {
                            signInWithGoogle()
                                .then((value) {
                                  userMgr.createUser(
                                      id: value.user!.uid,
                                      name: value.user!.displayName!,
                                    home_address: userMgr.location_data,
                                  );
                                  context.go("/tabs/map");
                                });
                            setState(() {
                              userMgr.active_user_id = (FirebaseAuth.instance.currentUser?.uid)!;
                              userMgr.active_user_name = (FirebaseAuth.instance.currentUser?.displayName)!;
                              // print("UserID: ${userMgr.active_user_id}, Name: ${userMgr.active_user_name}");

                              _isLoading = true;
                            });
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
                        );
                      })
                    ),
                  ]));
  }
}
