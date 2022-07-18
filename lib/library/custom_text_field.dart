import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextEditingController? confirmController;
  final String? hint;
  final int? valueLength;
  final int? maxLength;
  final bool? isObscure;
  final bool? autoFocus;
  final bool? isExist;
  final String? errorText;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

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
    this.valueLength = 0,
    this.onEditingComplete,
    this.errorText,
    this.isExist,
    this.confirmController,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus!,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: maxLength,
      decoration: InputDecoration(
        errorText: errorText,
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
      onEditingComplete: onEditingComplete,
      validator: (value) {
        if (controller.text.isEmpty) {
          return 'Please fill this field';
        } else if (controller.text.isNotEmpty) {
          if (controller.text.length < valueLength!) {
            return '$label length must be $valueLength';
          }

          if (isExist != null && isExist!) {
            return '$label already exist';
          }
          if (confirmController != null && confirmController != null) {
            if (confirmController!.text != controller.text) {
              return 'Confirm password does not match';
            }
          }
        }
        return null;
      },
    );
  }
}
