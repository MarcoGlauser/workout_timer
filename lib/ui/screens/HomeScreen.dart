import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/ui/screens/LoginScreen.dart';

class Login extends StatelessWidget {

  final Widget child;

  const Login({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUser>(
      builder: (context, user, __) {
        if (user == null) {
          FirebaseAuth.instance.signInAnonymously();
          return LoginScreen();
        } else {
          return child;
        }
      },
    );
  }
}
