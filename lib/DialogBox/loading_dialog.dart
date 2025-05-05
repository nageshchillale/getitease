import 'package:flutter/material.dart';
import 'package:getitease/Widgets/loading_widget.dart';
class LoadingDialog extends StatelessWidget {



  final String message;
  const LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         circularProgress(),
         const SizedBox(height: 10,),
          const Text('Please wait....')
      ],
      ),

    );
  }
}
