import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/forgot_password_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                const AuthHeader(title: 'Login'),
                const Spacer(),
                AuthBottomContainer(
                  children: [
                    const CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height * 0.05),
                    const CustomTextField(
                      label: 'Senha',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: false,
                            onChanged: (_) {},
                            activeColor: AppColors.secondary,
                            side: const BorderSide(color: AppColors.secondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Manter-se logado',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    AuthLinkText(
                      text: 'Esqueci minha ',
                      linkText: 'senha?',
                      centered: true,
                      fontSize: 16,
                      onLinkTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    SecondaryButton(
                      label: 'Entrar',
                      onPressed: () {},
                    ),
                    SizedBox(height: height * 0.05),
                    AuthLinkText(
                      text: 'Não possui uma conta? ',
                      linkText: 'Cadastra-se',
                      onLinkTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
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