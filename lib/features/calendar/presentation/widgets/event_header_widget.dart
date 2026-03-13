import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/core/utils/time_utils.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/event_editable_field_widget.dart';

class EventHeaderWidget extends StatelessWidget {
  final CalendarEventEntity event;
  final bool isEditing;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final VoidCallback onBackTap;
  final VoidCallback onEditSaveTap;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;

  const EventHeaderWidget({
    super.key,
    required this.event,
    required this.isEditing,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.startTime,
    required this.endTime,
    required this.onBackTap,
    required this.onEditSaveTap,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double topPadding = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(event.priorityColor),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: topPadding + 16),

              /// back button and edit/save toggle row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// back button navigates to previous screen
                  GestureDetector(
                    onTap: onBackTap,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      child: ColoredBox(
                        color: AppColors.FFFFFFFF,
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SvgPicture.asset(AppIcons.arrowBack),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// toggles between edit and save mode
                  GestureDetector(
                    onTap: onEditSaveTap,
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          AppIcons.edit,
                          colorFilter: const ColorFilter.mode(
                            AppColors.FFFFFFFF,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isEditing ? AppStrings.save : AppStrings.edit,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.FFFFFFFF,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// wrap fields in Form to enable validation
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// title
                    isEditing
                        ? EventEditableFieldWidget(
                            controller: titleController,
                            isEditing: isEditing,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.titleCannotBeEmpty;
                              }
                              return null;
                            },
                          )
                        : Text(
                            titleController.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.FFFFFFFF,
                            ),
                          ),
                    const SizedBox(height: 8),

                    /// description preview
                    isEditing
                        ? EventEditableFieldWidget(
                            controller: descriptionController,
                            isEditing: isEditing,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.descriptionCannotBeEmpty;
                              }
                              return null;
                            },
                          )
                        : Text(
                            descriptionController.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: AppColors.FFFFFFFF,
                            ),
                          ),
                    const SizedBox(height: 16),

                    /// time row
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          AppIcons.clock,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.FFFFFFFF,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),

                        /// start time
                        TimeTextWidget(
                          time: startTime,
                          isEditing: isEditing,
                          onTap: onStartTimeTap,
                        ),

                        const Text(
                          ' - ',
                          style: TextStyle(color: AppColors.FFFFFFFF),
                        ),

                        /// end time
                        TimeTextWidget(
                          time: endTime,
                          isEditing: isEditing,
                          onTap: onEndTimeTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// location icon and location text or text field
                    Row(
                      children: <Widget>[
                        /// location icon
                        SvgPicture.asset(
                          AppIcons.location,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.FFFFFFFF,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),

                        /// location text or text field
                        Expanded(
                          child: isEditing
                              ? EventEditableFieldWidget(
                                  controller: locationController,
                                  isEditing: isEditing,
                                  validator: (String? value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return AppStrings.locationCannotBeEmpty;
                                    }
                                    return null;
                                  },
                                )
                              : Text(
                                  locationController.text,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.FFFFFFFF,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeTextWidget extends StatelessWidget {
  final TimeOfDay? time;
  final bool isEditing;
  final VoidCallback onTap;

  const TimeTextWidget({super.key, 
    this.time,
    required this.isEditing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        TimeUtils.formatTime(time),
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: AppColors.FFFFFFFF,
          decoration: isEditing
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}
