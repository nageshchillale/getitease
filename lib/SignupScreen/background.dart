import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SignupBackground extends StatelessWidget {

  final Widget child;
  SignupBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.0], // Corrected stops
            tileMode: TileMode.clamp,
          )
        ),
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top :0,
            left: 0,
            child: Image.asset(
              "assets/images/images/main_top.png",
              color: Colors.blueAccent,
              width: size.width * 0.3,
          ),
          ),
          Positioned(
            bottom:0,
            right: 0,
            child: Image.asset(
              "assets/images/images/login_bottom.png",
              color: Colors.blueAccent,
              width: size.width * 0.29,
            ),
          ),
          child,
        ],
      ),

    );
  }
}
