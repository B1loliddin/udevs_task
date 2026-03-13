import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_strings.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final Widget? suffixIcon;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.pleaseFillOutField;
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
