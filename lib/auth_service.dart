import 'package:chatapp/homepage.dart';
import 'package:chatapp/messagescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const HomePage();
      } else if (snapshot.data != null) {
        return const MessageScreen();
      } else {
        return const HomePage();
      }
    });
  }
}
