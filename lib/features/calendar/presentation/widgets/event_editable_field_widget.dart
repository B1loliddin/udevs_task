import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';

class EventEditableFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;
  final int maxLines;
  final String? Function(String?)? validator;

  const EventEditableFieldWidget({
    super.key,
    required this.controller,
    required this.isEditing,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: isEditing,
      validator: validator,
      style: const TextStyle(
        fontSize: 13,
        fontFamily: 'Poppins',
        color: AppColors.FFFFFFFF,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: isEditing,
        disabledBorder: InputBorder.none,
        fillColor: AppColors.FFFFFFFF.withValues(alpha: 0.15),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.FFFFFFFF.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.FFFFFFFF),
        ),
      ),
    );
  }
}
