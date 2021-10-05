import 'package:assignment_tracker/auth/services.dart';
import 'package:assignment_tracker/main.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: ElevatedButton(
        onPressed: () => {AuthService.googleLogin()},
        child: Text("Sign in with Google"),
      )),
    );
  }
}
