import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
    );
  }
}
