import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
                    const CustomTextField(
                      label: 'Código recebido por e-mail',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: height * 0.03),
                    const CustomTextField(
                      label: 'Nova senha',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.03),
                    const CustomTextField(
                      label: 'Repita a nova senha',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.05),
                    SecondaryButton(
                      label: 'Alterar Senha',
                      onPressed: () {},
                    ),
                    SizedBox(height: height * 0.02),
                    AuthLinkText(
                      text: 'Lembrou a senha? ',
                      linkText: 'Voltar ao login',
                      onLinkTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      ),
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