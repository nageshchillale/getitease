import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getitease/ForgetPassword/background.dart';

import '../DialogBox/error_dialog.dart';
import '../LoginScreen/login_screen.dart';
class ForgetBody extends StatefulWidget {


  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPassTextController = TextEditingController(text: '');



  void _forgetPassSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgetPassTextController.text.trim());
      // Optional: show success dialog/snackbar before redirecting
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to your email.')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(message: error.toString()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ForgetBackground(
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40 , vertical: 40),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.2,),
                Text(
                  'Forget Password' ,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Email Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: _forgetPassTextController,
                  decoration: const InputDecoration(
                    hintText: 'Enter registered College Email',
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontFamily: 'Quicksand',
                    ),
                    filled: true,
                    fillColor: Colors.lightBlue,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),

                    ),

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),

                    ),
                    ),

                ),
                const SizedBox(height: 50,),
                  MaterialButton(
                    onPressed: ()
                    {
                      _forgetPassSubmitForm();
                    },
                    color: Colors.blueAccent,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Quicksand',
                      ),
                    ),

                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
