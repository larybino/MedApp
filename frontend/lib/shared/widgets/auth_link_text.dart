import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
    this.centered = true,
    this.fontSize = 18,
    this.linkColor = AppColors.secondary,
  });

  final String text;
  final String linkText;
  final VoidCallback onLinkTap;
  final bool centered;
  final double fontSize;
  final Color linkColor;

  @override
  Widget build(BuildContext context) {
    final widget = RichText(
      textAlign: centered ? TextAlign.center : TextAlign.start,
      text: TextSpan(
        text: text,
        style: GoogleFonts.dmSans(
          fontSize: fontSize,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: linkText,
            style: TextStyle(
              fontSize: fontSize,
              color: linkColor,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );

    if (centered) {
      return Center(child: widget);
    }
    return widget;
  }
}
