import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';

abstract class ColorUtils {
  static Color getTextColor(int priorityColor) {
    if (priorityColor == AppColors.FF009FEE.toARGB32()) {
      return AppColors.FF056EA1;
    }
    if (priorityColor == AppColors.FFEE2B00.toARGB32()) {
      return AppColors.FFBF2200;
    }
    if (priorityColor == AppColors.FFEE8F00.toARGB32()) {
      return AppColors.FFB86E00;
    }
    return AppColors.FF056EA1;
  }
}
