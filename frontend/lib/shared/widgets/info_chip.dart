import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: resolved.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: resolved),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: resolved,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
