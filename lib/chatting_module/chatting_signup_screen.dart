import 'package:chatting_app/11-03-2025/home_screen.dart';
import 'package:chatting_app/chatting_module/chatting_home_screen.dart';
import 'package:chatting_app/chatting_module/chatting_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChattingSignupScreen extends StatefulWidget {
  const ChattingSignupScreen({super.key});

  @override
  State<ChattingSignupScreen> createState() => _ChattingSignupScreenState();
}

class _ChattingSignupScreenState extends State<ChattingSignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
            TextFormField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                hintText: 'confirm password',
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
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    final userId = userCredential.user!.uid;
                    final userEmail = userCredential.user!.email;
                    print('user id --------->$userId');
                    print('user email --------->$userEmail');

                    await FirebaseFirestore.instance
                        .collection('chatting_users')
                        .doc(userId)
                        .set({
                      'uid': userId,
                      'uEmail': userEmail,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Account created')));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChattingHomeScreen()));
                    setState(() {
                      loading = false;
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error $error')));
                    setState(() {
                      loading = false;
                    });
                  }
                },
                child: loading ? CircularProgressIndicator() : Text('Sign Up')),
            SizedBox(
              height: 20,
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingLoginScreen()));
            }, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
