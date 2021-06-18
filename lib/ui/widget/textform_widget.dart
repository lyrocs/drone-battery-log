import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextInputType textInputType;
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final Function(String value) onChange;

  const MyTextField({
    required this.textInputType,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.onChange,
    Key? key

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      decoration: InputDecoration(labelText: label,
        hintText: placeholder,
        labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily: 'AvenirLight'
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey,
                width: 1.0)
        ),
      ),
      style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontFamily: 'AvenirLight'
      ),
      controller: controller,
      onChanged: onChange,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter value';
        }
        return null;
      },
    );
  }
}