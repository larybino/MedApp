import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/auth/screens/splash_screen.dart';
import 'package:frontend/features/user/screens/user_profile_screen.dart';
import 'package:frontend/shared/widgets/bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(width: width * 0.05),
                Text(
                  'Olá Usuário',
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileScreen(),
                        ),
                      );
                    },
                    textColor: AppColors.secondary,
                  ),
                  const Divider(height: 1, color: AppColors.lightGrey),
                  ListTile(
                    leading: Icon(Icons.person_pin_sharp),
                    title: Text('Gerenciar perfis'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileScreen(),
                        ),
                      );
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                      );                    },
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
        onTap: (index) {
          // Implementar navegação
        },
      ),
    );
  }
}