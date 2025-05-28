import 'package:chat_sdk/core/consts.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField(
      {super.key, this.hint, this.submit, this.change, this.obscure = false});

  final bool obscure;
  final String? hint;
  final Function(String)? change;
  final Function(String)? submit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: submit,
      onChanged: change,
      obscureText: obscure,
      validator: (value) {
        if (value!.isEmpty) {
          return 'the text is empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 131, 133, 134)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: baseColor1, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: baseColor1, width: 2),
        ),
      ),
    );
  }
}
