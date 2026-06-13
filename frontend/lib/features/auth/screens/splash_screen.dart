import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.35),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: height * 0.08),
                  const AuthHeader(title: ''),
                  const Spacer(),
                  AppButton(
                    label: 'Crie sua conta',
                    onPressed: () {
                      context.go(Routes.register);
                    },
                  ),
                  SizedBox(height: height * 0.12),
                  AuthLinkText(
                    text: 'Já possui uma conta? ',
                    linkText: 'Entrar',
                    linkColor: AppColors.primary,
                    onLinkTap: () {
                      context.go(Routes.login);
                    },
                  ),
                  SizedBox(height: height * 0.08),
                  Row(children: [
                    const Expanded(
                      child: Divider(
                        color: AppColors.textPrimary,
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou conecte-se com',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.textPrimary,
                        thickness: 2,
                      ),
                    ),
                  ]),
                  SizedBox(height: height * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialBtn(Icons.g_mobiledata),
                      const SizedBox(width: 12),
                      _socialBtn(Icons.facebook),
                      const SizedBox(width: 12),
                      _socialBtn(Icons.apple),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(IconData icon) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.secondary,
      border: Border.all(color: AppColors.secondary, width: 1.5),
    ),
    child: Center(
      child: Icon(
        icon,
        color: Colors.white70,
        size: 24,
      ),
    ),
  );
}