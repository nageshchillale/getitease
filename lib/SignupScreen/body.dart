import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getitease/ForgetPassword/forget_password.dart';
import 'package:getitease/HomeScreen/home_screen.dart';
import 'package:getitease/LoginScreen/login_screen.dart';
import 'package:getitease/Widgets/rounded_button.dart';
import 'package:getitease/Widgets/rounded_password_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../DialogBox/error_dialog.dart';
import '../Widgets/already_have_an_account_check.dart';
import '../Widgets/global_var.dart';
import '../Widgets/rounded_input_field.dart';
import 'background.dart';
class SignupBody extends StatefulWidget {


  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {


  String userPhotoUrl = '';
  File? _image;
  bool _isLoading= false;


  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  final FirebaseAuth _auth= FirebaseAuth.instance;

  void _getFromCamera() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
  
  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080 , maxWidth: 1080
    );

    if(croppedImage != null)
      {
        setState(() {
          _image = File(croppedImage.path);
        });
      }
  }

  void _showImageDialog()
  {
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: const Text('Please choose an Option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: ()
                      {
                         _getFromCamera();
                      },
                  child: Row(
                    children: const [
                      Padding(
                          padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.camera, color: Colors.blue,
                        ),
                      ),
                      Text('Camera', style: TextStyle(color: Colors.blue),)

                    ],
                  ),
                ),

                InkWell(
                  onTap: ()
                  {
                    _getFromGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.image, color: Colors.blue,
                        ),
                      ),
                      Text('Gallery', style: TextStyle(color: Colors.blue),)

                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void submitFormOnSignUp() async
  {

    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) return;

    signUpFormKey.currentState!.save();
    if(isValid)
      {
        if(_image == null)
          {
            showDialog(
                context: context,
                builder: (context)
                {
                  return const ErrorDialog(
                    message : 'Please pick an image',
                  );
                }
            );
            return;
          }
        setState(() {
          _isLoading= true;
        });

        try{
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim().toLowerCase(),
              password: _passwordController.text.trim(),
          );

          final User? user = _auth.currentUser;
          uid= user!.uid;

          final ref = FirebaseStorage.instance.ref().child('userImage').child(uid + '.jpg');
          await ref.putFile(_image!);
          userPhotoUrl = await ref.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'userName' : _nameController.text.trim(),
              'id' : uid,
              'userNumber' : _phoneController.text.trim(),
              'userEmail' : _emailController.text.trim(),
              'userPhotoUrl' : userPhotoUrl,
              'time' : DateTime.now(),
              'status' : 'approved',
            }

          );

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreen()));

          }

        catch(error)
    {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => ErrorDialog(message: error.toString()),
        );

    }
      }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width ,
        screenHeight = MediaQuery.of(context).size.height;

    return SignupBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: signUpFormKey,
            child: InkWell(
              onTap: ()
            {
               _showImageDialog();
            },
              child : CircleAvatar(
                radius:  screenWidth *0.20,
                backgroundColor: Colors.blueGrey,
                backgroundImage: _image == null ? null : FileImage(_image!),
                child: _image == null ? Icon(
                  Icons.camera_enhance,
                  color: Colors.black54,
                  size: screenWidth * 0.18,
                )
                    : null,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02,),
          RoundedInputField(
            hinttext: 'Name',
            icon: Icons.person,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          RoundedInputField(
            hinttext: 'Email',
            icon: Icons.email,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your college email';
              }

              final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@walchandsangli\.ac\.in$');

              if (!emailRegex.hasMatch(value.trim())) {
                return 'Only Walchand Sangli college emails are allowed';
              }

              return null;
            },
          ),

          RoundedInputField(
            hinttext: 'Phone no.',
            icon: Icons.phone,
            controller: _phoneController,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          RoundedPasswordField(
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 5,),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
            },
              child: const Text(
                'Forget Password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          _isLoading
          ?
              Center(
                child: Container(
                  height: 60,
                  width: 60,
                  child: const CircularProgressIndicator(),

                ),

              )
           :
              RoundedButton(
                  text: 'Sign up',
                  press: ()
                  {
                    submitFormOnSignUp();
                  }
              ),
           SizedBox(
             height: screenHeight * 0.03),
             AlreadyHaveAnAccountCheck(
               login: false,
               press: ()
                 {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                 },

             ),
          ],
        ),
      ),
    );
  }
}
