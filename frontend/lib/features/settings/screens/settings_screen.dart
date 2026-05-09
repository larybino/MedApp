import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/core/storage/secure_storage.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/input_utils.dart';
import 'package:frontend/features/auth/screens/splash_screen.dart';
import 'package:frontend/features/service/user_service.dart';
import 'package:frontend/features/user/screens/user_profile_screen.dart';
import 'package:frontend/shared/widgets/index.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _userService = UserService();
  Map<String, dynamic>? _userData;
  Uint8List? _profileImageBytes;
  bool _isLoading = true;

   @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      final userData = await _userService.getProfile(userId);
      setState(() {
        _userData = userData.toJson();
        _profileImageBytes = InputUtils.decodeBase64Image(userData.profilePicture);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorMessage.show(context, e.toString());
    }
  }
  
  
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
                  backgroundImage: _profileImageBytes != null
                            ? MemoryImage(_profileImageBytes!)
                            : null,
                  child: _profileImageBytes == null
                            ? const Icon(Icons.person, size: 44, color: AppColors.white)
                            : null,
                ),
                SizedBox(width: width * 0.05),
                Text(
                  _userData?["name"] ?? "",
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