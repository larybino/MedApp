import 'package:flutter/material.dart';
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
          // Background
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
                Text(
                  'MedApp',
                  style: GoogleFonts.manrope(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Recuperar Senha',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                const Spacer(),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 28,
                    right: 28,
                    top: height * 0.04,
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

                      Text(
                        'Email',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.dmSans(color: AppColors.secondary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Enviar',
                            style: GoogleFonts.syne(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Lembrou a senha? ',
                              style: GoogleFonts.dmSans(
                                color: AppColors.secondary,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Voltar ao login',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}