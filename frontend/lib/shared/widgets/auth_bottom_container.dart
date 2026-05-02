import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthBottomContainer extends StatelessWidget {
  const AuthBottomContainer({
    super.key,
    required this.children,
    this.height,
  });

  final List<Widget> children;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = height ?? screenHeight * 0.68;

    return SizedBox(
      width: double.infinity,
      height: containerHeight,
      child: Container(
        padding: EdgeInsets.only(
          left: 28,
          right: 28,
          top: screenHeight * 0.04,
          bottom: 32,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
