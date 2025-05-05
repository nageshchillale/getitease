import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getitease/ProfileScreen/profile_screen.dart';
import 'package:getitease/SearchProduct/search_product.dart';
import 'package:getitease/UploadAdScreen/upload_ad_screen.dart';
import 'package:getitease/WelcomeScreen/welcome_screen.dart';

import '../Widgets/global_var.dart';
import '../Widgets/listview_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()!['userPhotoUrl'];
        getUserName = results.data()!['userName'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          leading: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(sellerId: uid),
                ),
              );
            },
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),

          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5), // Keep logo vertically snug
            child: Image.asset(
              'assets/images/images/logo_three.png',
              height: 220, // Max height that still fits default AppBar
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SearchProduct()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.logout, color: Colors.white, size: 30),
              ),
            ),
          ],

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [1.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    final doc = snapshot.data!.docs[index];
                    print(
                        "Item Name: ${doc['itemName']}, URL 1: ${doc['urlImage1']}");
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
                      key: ValueKey(doc.id),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no tasks'),
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
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Post',
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UploadAdScreen()),
            );
          },
          child: const Icon(Icons.cloud_upload),
        ),
      ),
    );
  }
}
