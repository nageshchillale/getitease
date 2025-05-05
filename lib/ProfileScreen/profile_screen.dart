import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/home_screen.dart';
import '../Widgets/listview_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String sellerId;
  const ProfileScreen({required this.sellerId, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  QuerySnapshot? items;
  String profileImageUrl = '';
  String profileUserName = '';

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  void _getProfileData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.sellerId)
        .get();

    if (userDoc.exists) {
      setState(() {
        profileImageUrl = userDoc['userPhotoUrl'];
        profileUserName = userDoc['userName'];
      });
    }
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.home, color: Colors.white),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(profileImageUrl),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // fallback image logic if needed
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white70),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _buildBackButton(),
          title: Row(
            children: [
              _buildUserImage(),
              const SizedBox(width: 10),
              Text(profileUserName ,
                style: TextStyle(
                  color: Colors.white, // Change to any color you want
                  fontSize: 16,         // Optional: adjust font size
                  fontFamily: 'Quicksand', // Optional: make it bold
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('id', isEqualTo: widget.sellerId)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final doc = snapshot.data!.docs[index];
                    return ListviewWidget(
                      docId: doc.id,
                      img1: doc['urlImage1'],
                      img2: doc['urlImage2'],
                      img3: doc['urlImage3'],
                      postId: doc['id'],
                      userId: doc['id'],
                      itemName: doc['itemName'],
                      itemCon: doc['itemCon'],
                      description: doc['description'],
                      userNumber: doc['userNumber'],
                      date: doc['time'].toDate(),
                      userName: doc['userName'],
                      imgPro: doc['imgPro'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no items posted yet.'),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
