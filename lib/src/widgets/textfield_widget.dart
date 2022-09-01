import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key, 
    required this.title, 
    this.validator, 
    required this.onChanged, 
    this.textInputType, 
    this.textEditingController, 
    this.obscureText, this.icon, this.hintText}) : super(key: key);

  final String title;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChanged;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final bool? obscureText;
  final IconData? icon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          suffixIcon: Icon(icon),
          labelText: title,
          hintText: hintText
        ),
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: obscureText!,
        validator: validator, 
        onChanged: onChanged,
        style: const TextStyle(),
    );
  }
}
