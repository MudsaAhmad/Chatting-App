import 'dart:async';

import 'package:chatting_app/chatting_module/chatting_home_screen.dart';
import 'package:chatting_app/chatting_module/chatting_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChattingSplashScreen extends StatefulWidget {
  const ChattingSplashScreen({super.key});

  @override
  State<ChattingSplashScreen> createState() => _ChattingSplashScreenState();
}

class _ChattingSplashScreenState extends State<ChattingSplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), checkUser);
  }

  // check user if exist or not
  void checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChattingHomeScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChattingSignupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
