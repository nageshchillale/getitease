import 'package:flutter/material.dart';

circularProgress()
{
 return Container(
   alignment: Alignment.center,
   padding: EdgeInsets.only(top: 12.0),
   child: CircularProgressIndicator(
     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
   ),
 );
}