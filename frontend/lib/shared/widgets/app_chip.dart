import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.isSelected = false,
    this.onTap,
    this.borderRadius = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.fontSize = 10,
  });

  factory AppChip.selectable({
    Key? key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppChip(
      key: key,
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fontSize: 13,
      color: isSelected ? AppColors.primary : AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? AppColors.primary;
    final isInteractive = onTap != null;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isInteractive
            ? (isSelected ? AppColors.primary : AppColors.white)
            : resolvedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isInteractive
            ? Border.all(color: isSelected ? AppColors.primary : AppColors.lightGrey)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: resolvedColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: isInteractive
                  ? (isSelected ? Colors.white : AppColors.secondary)
                  : resolvedColor,
              fontSize: fontSize,
              fontWeight: isSelected || !isInteractive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );

    if (isInteractive) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}