import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/features/service/auth_service.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
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
                            ? const Icon(Icons.person, size: 44, color: AppColors.white)
                            : null,
                ),
                SizedBox(width: width * 0.05),
                Text(
                  user?.name ?? "",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondary),
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
                      final updated = await context.push<bool>(Routes.userProfile);
                      if (updated == true) {
                        await context.read<UserProvider>().refreshUser();
                      }
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  if(userProvider.isMaster)
                    ListTile(
                      leading: Icon(Icons.person_pin_sharp),
                      title: Text('Gerenciar perfis'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      iconColor: AppColors.secondary,
                      onTap: () async {
                        final updated = await context.push<bool>(Routes.members);
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
                      final updated = await context.push<bool>(Routes.changePassword);
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
                    },
                    textColor: AppColors.secondary,
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