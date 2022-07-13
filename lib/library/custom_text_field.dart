import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;

  final TextEditingController controller;
  final String? hint;
  final bool? isObscure;
  final bool? autoFocus;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatter,
    this.onChanged,
    this.hint,
    this.onSubmitted,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus!,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      obscureText: isObscure!,
      enableSuggestions: true,
      keyboardType: inputType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: (value) {
        if (controller.text.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }
}
