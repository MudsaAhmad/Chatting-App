import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChattingScreen extends StatefulWidget {
  final String email;
  final String uid;
  const ChattingScreen({super.key, required this.email, required this.uid});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    print('Email ----> ${widget.email} and uid ---> ${widget.uid}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
    );
  }
}
