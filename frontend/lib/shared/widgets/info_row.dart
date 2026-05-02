import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
	final IconData icon;
	final String label;
	final String value;
	final double? iconSize;
	final double? spacing;

	const InfoRow({
		super.key,
		required this.icon,
		required this.label,
		required this.value,
		this.iconSize,
		this.spacing,
	});

	@override
	Widget build(BuildContext context) {
		final width = MediaQuery.of(context).size.width;
		return Row(
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				Icon(icon, color: AppColors.secondary, size: iconSize ?? 20),
				SizedBox(width: spacing ?? width * 0.03),
				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								label,
								style: Theme.of(context).textTheme.labelSmall?.copyWith(
									color: AppColors.textSecondary,
									fontWeight: FontWeight.w500,
									letterSpacing: 0.2,
								),
							),
							const SizedBox(height: 2),
							Text(
								value,
								style: Theme.of(context).textTheme.titleMedium?.copyWith(
									fontWeight: FontWeight.bold,
									color: AppColors.textSecondary,
								),
							),
						],
					),
				),
			],
		);
	}
}
