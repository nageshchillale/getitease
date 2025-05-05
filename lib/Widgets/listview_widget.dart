import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../ImageSliderScreen/image_slider_screen.dart';
import 'global_var.dart';

class ListviewWidget extends StatefulWidget {
  late final String docId;
  late final String img1;
  late final String img2;
  late final String img3;
  late final String postId;
  late final String userId;
  late final String itemName;
  late final String itemCon;
  late final String description;
  late final String userNumber;
  late final String userName;
  late final String imgPro;
  late final DateTime date;

  ListviewWidget({
    required this.docId,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.imgPro,
    required this.postId,
    required this.userId,
    required this.itemName,
    required this.itemCon,
    required this.description,
    required this.userNumber,
    required this.date,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  State<ListviewWidget> createState() => _ListviewWidgetState();
}

class _ListviewWidgetState extends State<ListviewWidget> {
  Future<Future> showDialogForUpdate(selectedDoc,
      oldUserName,
      oldPhoneNumber,
      oldItemCon,
      oldItemName,
      oldDescription) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.blueAccent,
              title: const Text(
                'Update Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Quicksand',
                  letterSpacing: 2.0,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: oldUserName,
                    decoration: const InputDecoration(
                      hintText: 'Enter New User Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldUserName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    initialValue: oldPhoneNumber,
                    decoration: const InputDecoration(
                      hintText: 'Enter new Phone no.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldPhoneNumber = value;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    initialValue: oldItemCon,
                    decoration: const InputDecoration(
                      hintText: 'Update Contact details',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemCon = value;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    initialValue: oldItemName,
                    decoration: const InputDecoration(
                      hintText: 'Update Item Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    initialValue: oldDescription,
                    decoration: const InputDecoration(
                      hintText: 'Enter New Description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldDescription = value;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateUserName(oldUserName, oldPhoneNumber);
                    updateProfileNameOnExistingPosts(oldUserName);

                    FirebaseFirestore.instance
                        .collection('items')
                        .doc(selectedDoc)
                        .update({
                      'userName': oldUserName,
                      'userNumber': oldPhoneNumber,
                      'itemCon': oldItemCon,
                      'itemName': oldItemName,
                      'description': oldDescription,
                    }).catchError((onError) {
                      print(onError);
                    });

                    Fluttertoast.showToast(
                      msg: 'Data Updated Successfully',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.blueAccent,
                      fontSize: 18.0,
                    );
                  },
                  child: const Text('Update Now',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          );
        });
  }

  updateProfileNameOnExistingPosts(oldUserName) async {
    await FirebaseFirestore.instance
        .collection('items')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int index = 0; index < snapshot.docs.length; index++) {
        String userProfileName = snapshot.docs[index]['userName'];

        if (userProfileName != oldUserName) {
          FirebaseFirestore.instance
              .collection('items')
              .doc(snapshot.docs[index].id)
              .update({
            'userName': oldUserName,
          });
        }
      }
    });
  }

  Future _updateUserName(oldUserName, oldPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': oldUserName,
      'userNumber': oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        height: 330, // reduced overall card height
        child: Card(
          elevation: 5.0,
          shadowColor: Colors.black,
          color: Colors.blue,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Adjust the radius for less roundness
          ),// Set card color to blueAccent
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageSliderScreen(
                              itemName: widget.itemName,
                              userNumber: widget.userNumber,
                              userName: widget.userName,
                              itemCon: widget.itemCon,
                              imgPro: widget.imgPro,
                              description: widget.description,
                              urlImage1: widget.img1,
                              urlImage2: widget.img2,
                              urlImage3: widget.img3,
                            ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      widget.img1,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error_outline, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 9.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.imgPro.isNotEmpty &&
                            (widget.imgPro.startsWith('http') ||
                                widget.imgPro.startsWith('https'))
                            ? NetworkImage(widget.imgPro)
                            : const AssetImage(
                            'assets/images/images/default_profile.png')
                        as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint('Error loading profile image: $exception');
                        },
                      ),
                      const SizedBox(width: 9.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Text color changed to white

                                fontFamily: 'Quicksand',
                              ),
                            ),
                            Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white, // Text color changed to white

                                fontFamily: 'Quicksand',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Quicksand',// Text color changed to white
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('dd MMM yyyy - hh:mm a')
                                  .format(widget.date),
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                color: Colors.white, // Text color changed to white
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.userId == uid)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialogForUpdate(
                                  widget.docId,
                                  widget.userName,
                                  widget.userNumber,
                                  widget.itemCon,
                                  widget.itemName,
                                  widget.description,
                                );
                              },
                              icon: const Icon(
                                Icons.edit_note,
                                color: Colors.white, // Icon color changed to white
                                size: 24,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(widget.postId)
                                    .delete();
                                Fluttertoast.showToast(
                                  msg: 'Post Deleted Successfully',
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.blueAccent,
                                  fontSize: 16.0,
                                );
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white, // Icon color changed to white
                                size: 24,
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox(width: 40.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
