import 'package:flutter/material.dart';
import 'package:getitease/WelcomeScreen/welcome_screen.dart';
class ErrorDialog extends StatelessWidget {


  final String message;
  const ErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: ()
          {
            Navigator.pushReplacement(context , MaterialPageRoute(builder: (context) => WelcomeScreen()));
          },
          child: const Center(
            child: Text('OK'),
          ),
        ),
      ],

    );
  }
}
