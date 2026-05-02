import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                const AuthHeader(title: 'Cadastro'),
                const Spacer(),
                AuthBottomContainer(
                  children: [
                    const CustomTextField(
                      label: 'Nome',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: height * 0.02),
                    const CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height * 0.02),
                    const CustomTextField(
                      label: 'Senha',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.02),
                    const CustomTextField(
                      label: 'Confirmar senha',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.03),
                    SecondaryButton(
                      label: 'Cadastrar',
                      onPressed: () {},
                    ),
                    SizedBox(height: height * 0.05),
                    AuthLinkText(
                      text: 'Já possui uma conta? ',
                      linkText: 'Entrar',
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