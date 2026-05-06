import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/service/auth_service.dart';
import 'package:frontend/features/user/screens/user_profile_screen.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _register() async {
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showError('Preencha todos os campos');
      return;
    }
    setState(() => _isLoading = true);
    try{
      await _authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _confirmPasswordController.text,
      );
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro bem-sucedido!')),
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                const AuthHeader(title: 'Cadastro'),
                const Spacer(),
                AuthBottomContainer(
                  children: [
                    CustomTextField(
                      label: 'Nome',
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      label: 'Senha',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      label: 'Confirmar senha',
                      obscureText: true,
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: height * 0.03),
                    SecondaryButton(
                      label: 'Cadastrar',
                      onPressed: _register,
                      isLoading: _isLoading,
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