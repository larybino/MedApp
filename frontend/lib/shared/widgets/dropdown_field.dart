import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DropdownField extends StatelessWidget {
  final dynamic value;
  final List<DropdownMenuItem> items;
  final ValueChanged onChanged;

  const DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.white,
          style: const TextStyle(color: AppColors.secondary, fontSize: 14),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
