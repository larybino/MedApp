import 'package:flutter/material.dart';
import 'package:frontend/features/user/screens/user_profile_screen.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/forgot_password_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import '../../../core/theme/app_colors.dart';
import 'package:frontend/features/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Preencha todos os campos');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserProfileScreen()),
        );
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                const AuthHeader(title: 'Login'),
                const Spacer(),
                AuthBottomContainer(
                  children: [
                    CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    SizedBox(height: height * 0.05),
                    CustomTextField(
                      label: 'Senha',
                      obscureText: true,
                      controller: _passwordController,
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
                      onPressed: _login,
                      isLoading: _isLoading,
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