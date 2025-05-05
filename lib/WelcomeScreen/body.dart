import 'package:flutter/material.dart';
import 'package:getitease/SignupScreen/signup_screen.dart';
import 'package:getitease/WelcomeScreen/background.dart';
import 'package:getitease/Widgets/rounded_button.dart';

import '../LoginScreen/login_screen.dart';
class WelcomeBody extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'getItEase',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontFamily: 'Quicksand',

            ),
          ),
          SizedBox(height: size.height * 0.05,),
          Padding(
            padding: EdgeInsets.only(right: 1.0), // Adjust the value as needed
            child: Image.asset(
              'assets/images/images/logo.png',
              height: size.height * 0.4,
            ),
            
          ),
          RoundedButton(
            text: "Login",
            press: () {
               Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (context) => LoginScreen()));
            },

          ),
          RoundedButton(
            text: "Sign up",
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },

          )

        ],
      ),
    );
  }
}
