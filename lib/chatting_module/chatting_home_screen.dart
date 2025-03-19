import 'package:chatting_app/chatting_module/chatting_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatting_screen.dart';

class ChattingHomeScreen extends StatefulWidget {
  const ChattingHomeScreen({super.key});

  @override
  State<ChattingHomeScreen> createState() => _ChattingHomeScreenState();
}

class _ChattingHomeScreenState extends State<ChattingHomeScreen> {
  Stream<QuerySnapshot> getUsersData() {
    String currentUserId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    return FirebaseFirestore.instance
        .collection('chatting_users')
        .where('uid', isNotEqualTo: currentUserId) // Exclude current user
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChattingLoginScreen()));
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder(
          stream: getUsersData(),
          builder: (context, snapshot) {
            var userData = snapshot.data!.docs;

            print('user data -----> ${userData.toString()}');

            if (snapshot.hasError) {
              return Text('error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No data found');
            }

            return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  var showData = userData[index].data() as Map<String, dynamic>;

                  print('show data ------>${showData.toString()}');

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChattingScreen(
                                    email: '${showData['uEmail']}',
                                    uid: '${showData['uid']}',
                                  )));
                    },
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Email ${showData['uEmail']}'),
                      subtitle: Text('UID ${showData['uid']}'),
                    ),
                  );
                });
          }),
    );
  }
}
