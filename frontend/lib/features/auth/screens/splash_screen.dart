import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/core/storage/jwt_helper.dart';
import 'package:frontend/core/storage/secure_storage.dart';
import 'package:frontend/shared/widgets/index.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession());
  }

  Future<void> _checkSession() async {
    final token = await SecureStorage.getToken();

    if (token != null && token.isNotEmpty && !JwtHelper.isExpired(token)) {
      if (mounted) context.go(Routes.home);
      return;
    }

    if (token != null && token.isNotEmpty) {
      await SecureStorage.clear();
    }

    if (mounted) setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: height * 0.08),
                  const AuthHeader(title: ''),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            label: 'Crie sua conta',
                            onPressed: () {
                              context.go(Routes.register);
                            },
                          ),
                          SizedBox(height: height * 0.05),
                          AuthLinkText(
                            text: 'Já possui uma conta? ',
                            linkText: 'Entrar',
                            linkColor: AppColors.primary,
                            onLinkTap: () {
                              context.go(Routes.login);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
