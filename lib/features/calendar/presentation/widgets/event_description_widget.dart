import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/custom_text_field_widget.dart';

class EventDescriptionWidget extends StatelessWidget {
  final bool isEditing;
  final TextEditingController descriptionController;

  const EventDescriptionWidget({
    super.key,
    required this.isEditing,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// section label
          const Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: AppColors.FF292929,
            ),
          ),
          const SizedBox(height: 12),

          /// full description
          isEditing
              ? CustomTextFieldWidget(
                  controller: descriptionController,
                  maxLines: 5,
                )
              : Text(
                  descriptionController.text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: AppColors.FF6B6B6B,
                  ),
                ),
        ],
      ),
    );
  }
}
