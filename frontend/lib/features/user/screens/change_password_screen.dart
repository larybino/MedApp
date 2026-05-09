import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/features/service/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _userService = UserService();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    final currentPassword =
        _oldPasswordController.text.trim();

    final newPassword =
        _newPasswordController.text.trim();

    final confirmPassword =
        _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ErrorMessage.show(
        context,
        'Preencha todos os campos',
      );
      return;
    }

    if (newPassword.length < 6) {
      ErrorMessage.show(
        context,
        'A nova senha deve ter pelo menos 6 caracteres',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ErrorMessage.show(
        context,
        'As senhas não coincidem',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _userService.changePassword(
        {
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ErrorMessage.show(
        context,
        e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        width * 0.97 > 500
                            ? 500
                            : width * 0.97,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Senha Atual',
                        controller:
                            _oldPasswordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Nova Senha',
                        controller: _newPasswordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Confirmar Nova Senha',
                        controller:
                            _confirmPasswordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 32),

                      PrimaryButton(
                        label: 'Salvar Alterações',
                        onPressed: _changePassword,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}