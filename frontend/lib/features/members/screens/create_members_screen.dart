import 'package:flutter/material.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class CreateMemberScreen extends StatefulWidget {
  const CreateMemberScreen({super.key});

  @override
  State<CreateMemberScreen> createState() => _CreateMemberScreenState();
}

class _CreateMemberScreenState extends State<CreateMemberScreen> {
  bool _isNewProfile = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _memberCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _create() async {
    setState(() => _isLoading = true);
    try {
      if (_isNewProfile) {
        if (_nameController.text.isEmpty) {
          ErrorMessage.show(context, 'Nome é obrigatório');
          return;
        }
        await context.read<MemberProvider>().createMember(
          mode: 'NEW',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        if (_memberCodeController.text.isEmpty) {
          ErrorMessage.show(context, 'Informe o código do membro');
          return;
        }
        await context.read<MemberProvider>().createMember(
          mode: 'LINK',
          memberCode: _memberCodeController.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Erro ao criar membro');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _memberCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Membro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isNewProfile = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isNewProfile
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Criar perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isNewProfile
                                ? AppColors.white
                                : AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isNewProfile = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isNewProfile
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Vincular pelo código',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isNewProfile
                                ? AppColors.white
                                : AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            if (_isNewProfile) ...[
            CustomTextField(
              label: 'Nome',
              controller: _nameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: height * 0.02),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: height * 0.02),
            CustomTextField(
              label: 'Senha',
              controller: _passwordController,
              obscureText: true,
            ),
          ] else ...[
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Peça ao membro o código que aparece no perfil dele.',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                label: 'Código do membro',
                controller: _memberCodeController,
                keyboardType: TextInputType.text,
              ),
            ],
            SizedBox(height: height * 0.04),
            PrimaryButton(
              label: _isNewProfile ? 'Criar e vincular' : 'Vincular',
              onPressed: _create,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}