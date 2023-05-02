import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.labelText,
      required this.onSaved,
      required this.validator,
      required this.prefixIcon,
      this.keyboardType,
      this.suffixIcon,
      this.obscure = false,
      required this.textInputAction,
      this.controller,
      this.autovalidateMode});

  final String labelText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final Widget prefixIcon;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscure;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      obscureText: obscure,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        // errorText: validator != null ? validator(controller!.text) : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
