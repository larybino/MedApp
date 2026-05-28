import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/input_utils.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();

}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await context.read<UserProvider>().loadUser();
      } catch (e) {
        if (mounted) ErrorMessage.show(context, e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final isLoading = userProvider.isLoading;
    final formattedBirthDate = InputUtils.formatBirthDateForDisplay(user?.birthDate);
    final formattedGender = InputUtils.genderLabelFromValue(user?.gender);
    _profileImageBytes = InputUtils.decodeBase64Image(user?.profilePicture);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Usuário'),
        centerTitle: true,
      ),
      floatingActionButton: CustomFloatingActionButton(
        icon: Icons.edit,
        tooltip: 'Editar Perfil',
        onPressed: () async {
          final updated = await context.push<bool>(Routes.editUser);

          if (updated == true) {
            await context.read<UserProvider>().refreshUser();
          }
        },
      ),
        body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.darkGrey,
                        backgroundImage: _profileImageBytes != null
                            ? MemoryImage(_profileImageBytes!)
                            : null,
                        child: _profileImageBytes == null
                            ? const Icon(Icons.person, size: 44, color: AppColors.white)
                            : null,
                      ),
                      SizedBox(width: width * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? "",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondary),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width * 0.97 > 500 ? 500 : width * 0.97,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          children: [
                            InfoRow(icon: Icons.email, label: "Email", value: user?.email ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.cake, label: "Data de Nascimento", value: formattedBirthDate),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.phone, label: "Contato", value: user?.phone ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.wc, label: "Gênero", value: formattedGender),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.monitor_weight, label: "Peso", value: user?.weight != null ? "${user!.weight} kg" : ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.health_and_safety, label: "Associação/Classe", value: user?.association ?? ""),
                            if (user?.role == 'MEMBER')
                            InfoRow(
                              icon: Icons.qr_code,
                              label: 'Seu código',
                              value: user?.memberCode ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

}