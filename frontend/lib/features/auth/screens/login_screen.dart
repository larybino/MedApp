import 'package:flutter/material.dart';
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
                'Login',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: height * 0.68,
                child: Container(
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
                    Text('Email',
                      style: GoogleFonts.dmSans(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.dmSans(color: AppColors.secondary),
                      decoration: InputDecoration(
                        filled: true, fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    Text('Senha',
                      style: GoogleFonts.dmSans(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: true,
                      style: GoogleFonts.dmSans(color: AppColors.secondary),
                      decoration: InputDecoration(
                        filled: true, fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    Row(
                      children: [
                        SizedBox(
                          width: 20, height: 20,
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
                        Text('Manter-se logado',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,  fontWeight: FontWeight.w700, color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.05),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Entrar',
                          style: GoogleFonts.syne(
                            fontSize: 24, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Não possui uma conta? ',
                            style: GoogleFonts.dmSans(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(text: 'Cadastra-se',
                                style: TextStyle(fontSize: 18, color: AppColors.secondary,
                                  fontWeight: FontWeight.w800),
                                  // recognizer: TapGestureRecognizer()
                                  // ..onTap = () {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                      
                                  //     ),
                                  //   );
                                  // },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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