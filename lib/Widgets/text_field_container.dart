import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // ✅ Define `size` here

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      width: size.width * 0.8, // ✅ Now this works
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
