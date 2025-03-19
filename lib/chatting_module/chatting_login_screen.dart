import 'package:chatting_app/11-03-2025/home_screen.dart';
import 'package:chatting_app/chatting_module/chatting_home_screen.dart';
import 'package:chatting_app/chatting_module/chatting_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChattingLoginScreen extends StatefulWidget {
  const ChattingLoginScreen({super.key});

  @override
  State<ChattingLoginScreen> createState() => _ChattingLoginScreenState();
}

class _ChattingLoginScreenState extends State<ChattingLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'password',
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      loading = true;
                    });

                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Login success')));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingHomeScreen()));
                    setState(() {
                      loading = false;
                    });
                  } catch (error) {
                    print('error ---->$error');
                  }
                },
                child: loading ? CircularProgressIndicator() : Text('Login')),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChattingSignupScreen()));
                },
                child: Text('Sign up')),
          ],
        ),
      ),
    );
  }
}
