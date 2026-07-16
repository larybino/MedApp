import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/features/service/auth_service.dart';
import 'package:frontend/features/service/user_service.dart';
import 'package:frontend/features/settings/screens/about_screen.dart';
import 'package:frontend/features/settings/screens/notification_settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/input_utils.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Uint8List? _profileImageBytes;
  final _userService = UserService();

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
    _profileImageBytes = InputUtils.decodeBase64Image(user?.profilePicture);

    Future<void> deleteAccount() async {
      final userId = user?.id;
      if (userId == null) {
        ErrorMessage.show(context, 'Usuário não identificado');
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text('Essa ação é permanente. Deseja continuar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Excluir',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) {
        return;
      }

      try {
        await _userService.deleteAccount(userId);
        if (!mounted) return;
        context.read<UserProvider>().clearUser();
        await AuthService().logout();
        if (mounted) context.go(Routes.splash);
      } catch (e) {
        if (mounted) ErrorMessage.show(context, e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.darkGrey,
                  backgroundImage: _profileImageBytes != null
                      ? MemoryImage(_profileImageBytes!)
                      : null,
                  child: _profileImageBytes == null
                      ? const Icon(
                          Icons.person,
                          size: 44,
                          color: AppColors.white,
                        )
                      : null,
                ),
                SizedBox(width: width * 0.05),
                Text(
                  user?.name ?? "",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            Card(
              color: AppColors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Dados do perfil'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () async {
                      final updated = await context.push<bool>(
                        Routes.userProfile,
                      );
                      if (updated == true) {
                        await context.read<UserProvider>().refreshUser();
                      }
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  if (userProvider.isMaster)
                    ListTile(
                      leading: Icon(Icons.person_pin_sharp),
                      title: Text('Gerenciar perfis'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      iconColor: AppColors.secondary,
                      onTap: () async {
                        final updated = await context.push<bool>(
                          Routes.members,
                        );
                        if (updated == true) {
                          await context.read<MemberProvider>().loadMembers();
                        }
                      },
                      textColor: AppColors.secondary,
                    ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: Icon(Icons.key),
                    title: Text('Alterar senha'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () async {
                      final updated = await context.push<bool>(
                        Routes.changePassword,
                      );
                      if (updated == true) {
                        await context.read<UserProvider>().refreshUser();
                      }
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notificação'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Histórico de adesão'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    textColor: AppColors.secondary,
                    onTap: () => context.push(Routes.adherence),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Card(
              color: AppColors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Sobre nós'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      );
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sair'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () async {
                      context.read<UserProvider>().clearUser();
                      await AuthService().logout();
                      if (mounted) context.go(Routes.splash);
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: AppColors.secondary,
                    ),
                    title: Text('Excluir conta'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: deleteAccount,
                    textColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4,
        onTap: (index) => BottomNavHandler.navigate(context, index),
      ),
    );
  }
}
