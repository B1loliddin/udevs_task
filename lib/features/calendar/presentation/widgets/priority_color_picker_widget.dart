import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';

class PriorityColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const PriorityColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  State<PriorityColorPickerWidget> createState() =>
      _PriorityColorPickerWidgetState();
}

class _PriorityColorPickerWidgetState extends State<PriorityColorPickerWidget> {
  final List<Color> colors = <Color>[
    AppColors.FF009FEE,
    AppColors.FFEE2B00,
    AppColors.FFEE8F00,
  ];

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: GestureDetector(
            onTap: () => setState(() => isOpen = !isOpen),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.selectedColor,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: const SizedBox(width: 24, height: 24),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF2196F3),
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isOpen) ...<Widget>[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((Color color) {
              final bool isSelected = color == widget.selectedColor;

              return GestureDetector(
                onTap: () {
                  widget.onColorChanged(color);
                  setState(() => isOpen = false);
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  child: const SizedBox(width: 24, height: 24),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
