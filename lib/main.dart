import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'chatting_module/chatting_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAb3Dkvcai88ZDDXz01k82JuXg7VXAS3tk',
    appId: '1:225418999366:android:94b7d277c1231f08f8fc47',
    messagingSenderId: '225418999366',
    projectId: 'fypar-819e4',
    storageBucket: 'fypar-819e4.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChattingSplashScreen(),
    );
  }
}
