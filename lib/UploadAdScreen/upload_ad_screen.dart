import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getitease/DialogBox/loading_dialog.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../HomeScreen/home_screen.dart';
import '../Widgets/global_var.dart';



class UploadAdScreen extends StatefulWidget {


  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {


  String postId = Uuid().v4();


  bool uploading = false , next = false;

  final List<File> _image = [];

  final FirebaseAuth _auth= FirebaseAuth.instance;

  List<String> urlsList =[];

  String name ='';
  String phoneNo = '';
  double val= 0;
  String imgPro='';


  String itemName ='';
  String description ='';
  String itemCon ='';

  
  chooseImage() async
  {
   XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   setState(() {
     _image.add(File(pickedFile!.path));
   });
  }

  Future uploadFile() async
  {
    int i = 1;

    for(var img in _image)
    {
      setState(() {
        val = i / _image.length;
      });
      Reference ref = FirebaseStorage.instance.ref().child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
        });
      }
  }
  final uid = FirebaseAuth.instance.currentUser!.uid;
getNameOfUser()
{
  FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .get()
      .then((snapshot) async{

    if(snapshot.exists)
      {
        setState(() {
          name =snapshot.data()!['userName'];
          phoneNo =snapshot.data()!['userNumber'];
        });
      }
  });
}
@override
void initState()
{
  super.initState();
  getNameOfUser();

}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.0], // Corrected stops
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [1.0, 1.0], // Corrected stops
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          next ? 'Please write Item Info' : 'Choose Item Images'  ,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Quicksand',
          ),
        ),
        actions: [
          next ?
             Container()
              :
             ElevatedButton(
              onPressed: ()
              {
                //if(_image.length >= 1)
                  //{
                Fluttertoast.showToast(msg: 'You can select maximum 3 images');
                    setState(() {
                      uploading = true;
                      next = true;
                    });
                  //}
              },
               child: const Text(
                 'Next',
                 style: TextStyle(
                   fontSize: 17 ,
                   color: Colors.blueAccent,
                   fontFamily: 'Quicksand',
                 ),
               ) ,
              ),
        ],
      ),
    body: next
        ? SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
          mainAxisSize : MainAxisSize.min,
            children: [
              const SizedBox(height: 40.0,),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Item Name' ),
                onChanged: (value)
                  {
                     itemName =value;
                  },
              ),
              const SizedBox(height: 50.0,),
              TextField(
                decoration:const InputDecoration(hintText: 'Enter Item Description(with Location)' ),
                onChanged: (value)
                {
                   description = value;
                },
              ),
              const SizedBox(height: 50.0,),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Contact details' ),
                onChanged: (value)
                {
                   itemCon = value;
                },
              ),
              const SizedBox(height: 30.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.5,
                child: ElevatedButton(
                    onPressed: ()
                    {
                      showDialog(context: context, builder: (context)
                      {
                        return LoadingDialog(message: 'Uploading...');
                      });
                      uploadFile().whenComplete(()
                      {
                        FirebaseFirestore.instance.collection('items')
                            .doc(postId).set({
                          'userName' : name,
                          'id' : _auth.currentUser!.uid,
                          'postId' : postId,
                          'userNumber' : phoneNo,
                          'itemName' : itemName,
                          'description' : description,
                          'itemCon' : itemCon,
                          'urlImage1': urlsList.isNotEmpty ? urlsList[0] : '',
                          'urlImage2': urlsList.length > 1 ? urlsList[1] : '',
                          'urlImage3': urlsList.length > 2 ? urlsList[2] : '',
                          'time' : DateTime.now(),
                          'imgPro' : imgPro,
                          'status' : 'Approved',

                        });

                        Fluttertoast.showToast(msg: 'Data Uploaded',
                          toastLength: Toast.LENGTH_LONG ,
                          backgroundColor: Colors.blueAccent,
                          fontSize: 18.0,
                        );
                        Navigator.push(context ,
                          MaterialPageRoute(builder: (context) => HomeScreen()));

                      }).catchError((onError)
                          {
                            print(onError);
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.blueAccent, // Splash + ripple color
                      elevation: 2, // Optional: elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Upload it' ,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                ),
              )



            ],
      ),
      ),
    )
        :
        Stack(
          children: [
            Container(
              padding:const EdgeInsets.all(4),
              child: GridView.builder(
                itemCount: _image.length +1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ?
                  Center(
                    child: IconButton(
                      onPressed: () {
                        !uploading ? chooseImage() : null;
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue, // Background color
                          shape: BoxShape.circle, // Makes it circular
                        ),
                        padding: EdgeInsets.all(15), // Space inside the circle
                        child: Icon(
                          Icons.add,
                          color: Colors.white, // Icon color
                          size: 30, // Icon size (optional)
                        ),
                      ),
                      splashRadius: 28, // Optional: controls the splash effect size
                    ),
                  )

                      :
                  Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image[index - 1]),
                          fit: BoxFit.cover,
                        )
                    ),
                  );
                },
              ),
            ),
          uploading
            ?
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   const Text(
                      'Uploading...',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                   const SizedBox(height: 20,),
                    CircularProgressIndicator(
                      value: val,
                      valueColor:const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ],
                ),
              )

              :
              Container(),

          ],
        )

      ),
    );
  }
}
