import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final VoidCallback onDeleteTap;
  final String? iconPath;

  const CustomButtonWidget({
    super.key,
    required this.onDeleteTap,
    required this.backgroundColor,
    this.iconPath,
    required this.title,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    /// screenWidth and bottomPadding variables
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
        top: 16,
        bottom: bottomPadding > 0 ? bottomPadding : 16,
      ),
      child: GestureDetector(
        onTap: onDeleteTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// delete icon in red
                  iconPath != null
                      ? Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              iconPath!,
                              colorFilter: const ColorFilter.mode(
                                AppColors.FFE53935,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        )
                      : const SizedBox.shrink(),

                  /// delete event text
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
