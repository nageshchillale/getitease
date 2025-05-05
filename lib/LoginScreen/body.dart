import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getitease/SignupScreen/signup_screen.dart';
import '../DialogBox/loading_dialog.dart';
import '../DialogBox/error_dialog.dart';
import '../ForgetPassword/forget_password.dart';
import '../HomeScreen/home_screen.dart';
import '../Widgets/already_have_an_account_check.dart';
import '../Widgets/rounded_button.dart';
import '../Widgets/rounded_input_field.dart';
import '../Widgets/rounded_password_field.dart';
import 'background.dart';

class LoginBody extends StatefulWidget {
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth= FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   void _login() async
   {
     showDialog(
       context: context,
       builder: (_)
         {
           return LoadingDialog(message: 'Logging in...',);
         }

     );

     User? currentUser;


     await _auth.signInWithEmailAndPassword(
       email: _emailController.text.trim(),
       password: _passwordController.text.trim(),

     ).then((auth) {

       currentUser=auth.user;
     }).catchError((error)
         {
          Navigator.pop(context);
          showDialog(context: context, builder: (context)
          {
            return ErrorDialog(message: error.toString());
          });
         });

     if(currentUser != null)
       {
         Navigator.pop(context);
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
       }
     else {
       print('error..');
     }
   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.04),
              Image.asset(
                'assets/icons/icons/login.png',
                height: size.height * 0.25,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hinttext: 'Email',
                icon: Icons.email,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Enter a valid college email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              RoundedPasswordField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 1),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              RoundedButton(
                text: 'Login',
                press: ()
                  {
                    _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                        ? _login()
                        : showDialog(
                        context: context,
                      builder: (context)
                        {
                          return const ErrorDialog(message: 'Please fill all the fields');

                        }
                    );
                  },

              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: true,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
