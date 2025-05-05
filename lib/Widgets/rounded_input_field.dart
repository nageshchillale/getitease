import 'package:flutter/material.dart';
import 'package:getitease/Widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hinttext;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const RoundedInputField({
    Key? key,
    required this.hinttext,
    this.icon = Icons.person,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        validator: validator,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hinttext,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
