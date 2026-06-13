import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/features/service/auth_service.dart';
import 'package:frontend/shared/widgets/index.dart';

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
      ErrorMessage.show(context, 'Preencha todos os campos');
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
      context.go(Routes.settings);
      }
    } catch (e) {
       if (mounted) ErrorMessage.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.35),
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
                      enableObscureToggle: true,
                      controller: _passwordController,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      label: 'Confirmar senha',
                      obscureText: true,
                      enableObscureToggle: true,
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: height * 0.02),
                    AppButton(
                      label: 'Cadastrar',
                      onPressed: _register,
                      variant: ButtonVariant.secondary,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: height * 0.03),
                    AuthLinkText(
                      text: 'Já possui uma conta? ',
                      linkText: 'Entrar',
                      onLinkTap: () => context.go(Routes.login),
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