import 'package:chatting_app/chatting_module/chatting_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final timeStamp = Timestamp.now();

  // send message
  Future<void> sendMessage() async {
    print(
        'send message data ----> $currentUserId email $currentUserEmail time $timeStamp reciverId ${widget.uid}');

    ChattingModel newMessage = ChattingModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail.toString(),
        recieverId: widget.uid,
        message: messageController.text,
        timestamp: timeStamp);

    List<String> ids = [currentUserId, widget.uid];
    print('ids -------> $ids');
    ids.sort();
    final combineIds = ids.join("_");
    print('ids -------> $combineIds');

    await FirebaseFirestore.instance
        .collection('smit_chatting')
        .doc(combineIds)
        .collection('smit_messages')
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages() {
    List<String> ids = [currentUserId, widget.uid];
    print('ids -------> $ids');
    ids.sort();
    final combineIds = ids.join("_");
    print('ids -------> $combineIds');
    return FirebaseFirestore.instance
        .collection("smit_chatting")
        .doc(combineIds)
        .collection('smit_messages').orderBy(
      'timestamp',
      descending: false,
    )
        .snapshots();

    //orderBy(
    //         'timeStamp' : timeStamp,
    //         descending: false,
    //       )
  }

  @override
  Widget build(BuildContext context) {
    print('Email ----> ${widget.email} and uid ---> ${widget.uid}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: buildMessagesList()),
            buildUserPrompt(),
          ],
        ),
      ),
    );
  }

  // user prompt text field
  Widget buildUserPrompt() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'enter message',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
                messageController.clear();
              }
            },
            icon: const Icon(Icons.send)),
      ],
    );
  }

  // single message show
  Widget buildMessage(QueryDocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue.shade200 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7, // Message width limit
          ),
          child: Column(
            children: [
              Text(
                data['message'],
                style: TextStyle(fontSize: 16),
              ),
              Text(
                data['senderEmail'],
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // List of messages show

  Widget buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
        stream: getMessages(),
        builder: (context, snapshot) {
          // var data =  snapshot.data as Map<String, dynamic>;
          // print('data --------> ${data.toString()}');

          if (snapshot.hasError) {
            return Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data found');
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) => buildMessage(doc)).toList(),
          );
        });
  }
}
