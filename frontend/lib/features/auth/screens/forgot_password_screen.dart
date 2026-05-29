import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/features/service/auth_service.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      ErrorMessage.show(context, 'Preencha o campo de email');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.forgotPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código de redefinição enviado!')),
        );
        context.go(Routes.resetPassword);
        }
    } catch(e){
      ErrorMessage.show(context, e.toString());
    }finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.08),
                const AuthHeader(title: 'Recuperar Senha'),
                const Spacer(),
                AuthBottomContainer(
                  children: [
                    Text(
                      'Informe seu e-mail cadastrado e será enviado um código para redefinir sua senha.',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: AppColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    SizedBox(height: height * 0.03),
                    SecondaryButton(
                      label: 'Enviar',
                      onPressed: _forgotPassword,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: height * 0.02),
                    AuthLinkText(
                      text: 'Lembrou a senha? ',
                      linkText: 'Voltar ao login',
                      onLinkTap: () => context.go(Routes.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}