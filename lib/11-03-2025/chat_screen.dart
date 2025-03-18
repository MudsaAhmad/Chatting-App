import 'package:chatting_app/11-03-2025/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserId;
  const ChatScreen(
      {super.key,
      required this.recieverUserEmail,
      required this.recieverUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final messageController = TextEditingController();

  // function for send message
  Future<void> sendMessage(String recieverId, String message) async {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy(
          'timeStamp',
          descending: false,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          //Text('Email ${widget.recieverUserEmail} UID ${widget.recieverUserId}'),
          Expanded(child: buildMessageList()),
          messageInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
        stream:
            getMessages(widget.recieverUserId, firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text('error: ${snapshot.error.toString()}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Text('Loading');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == firebaseAuth.currentUser?.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == firebaseAuth.currentUser?.uid) ?
          CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
          (data['senderId'] == firebaseAuth.currentUser?.uid) ?
          MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderId']),
           Container(
             width: 200,
             color: Colors.blueAccent,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Center(child: Text(data['message'])),
               )),
          ],
        ),
      ),
    );
  }

  Widget messageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: InputDecoration(
              hintText: 'Enter text',
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage(widget.recieverUserId, messageController.text);
                messageController.clear();
              }
            },
            icon: Icon(Icons.send)),
      ],
    );
  }
}
