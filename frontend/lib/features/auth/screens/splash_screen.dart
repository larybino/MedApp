import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  Text('MedApp',
                    style: GoogleFonts.manrope(
                      fontSize: 52, fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    )),
                  const Spacer(),
                 SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Crie sua conta',
                        style: GoogleFonts.syne(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        text: 'Já possui uma conta? ',
                        style: GoogleFonts.dmSans(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: 'Entrar',
                            style: TextStyle(fontSize: 18, color: AppColors.primary,
                              fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Row(children: [
                    const Expanded(
                        child: Divider(
                          color: AppColors.textPrimary,
                          thickness: 2,
                        ),
                      ),                    
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou conecte-se com',
                        style: GoogleFonts.dmSans(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    ),
                      const Expanded(
                        child: Divider(
                          color: AppColors.textPrimary,
                          thickness: 2,
                        ),
                      ),                  
                    ]),
                  const SizedBox(height: 70),
                  // Botões sociais
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
    width: 44, height: 44,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.surface,
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