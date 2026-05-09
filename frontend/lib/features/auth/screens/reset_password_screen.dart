import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/features/service/auth_service.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_codeController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ErrorMessage.show(context, 'Preencha todos os campos');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ErrorMessage.show(context, 'As senhas não coincidem');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.resetPassword(
        _codeController.text.trim(),
        _newPasswordController.text,
        _confirmPasswordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso!')),
        );
        context.go(Routes.login);
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.08),
                const AuthHeader(title: 'Redefinir Senha'),
                const Spacer(),
                AuthBottomContainer(
                  height: height * 0.72,
                  children: [
                    Text(
                      'Enviamos um código para:',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: AppColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'seu e-mail cadastrado',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      label: 'Código recebido por e-mail',
                      keyboardType: TextInputType.number,
                      controller: _codeController,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      label: 'Nova senha',
                      obscureText: true,
                      controller: _newPasswordController,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      label: 'Repita a nova senha',
                      obscureText: true,
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: height * 0.05),
                    SecondaryButton(
                      label: 'Alterar Senha',
                      onPressed: _resetPassword,
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
            )
          ),
        ],
      ),
    );
  }
}