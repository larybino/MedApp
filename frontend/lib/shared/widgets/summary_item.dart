import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;

  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? color
                    : AppColors.secondary.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
