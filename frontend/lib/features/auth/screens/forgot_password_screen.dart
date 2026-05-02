import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                    const CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height * 0.03),
                    SecondaryButton(
                      label: 'Enviar',
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