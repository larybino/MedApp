import 'package:flutter/material.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/core/storage/secure_storage.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/service/user_service.dart';
import 'package:frontend/shared/widgets/index.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();

}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _userService = UserService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = await SecureStorage.getUserId();
      print('User ID recuperado: $userId'); // Log para depuração
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      final userData = await _userService.getProfile(userId);
      setState(() {
        _userData = userData.toJson();
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
        title: const Text('Dados do Usuário'),
        centerTitle: true,
      ),
      floatingActionButton: CustomFloatingActionButton(
        icon: Icons.edit,
        tooltip: 'Editar Perfil',
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.editUser,
          );
        },
      ),
      body: _isLoading
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
                        child: const Icon(Icons.person, size: 44, color: AppColors.white),
                      ),
                      SizedBox(width: width * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userData?["name"] ?? "",
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
                            InfoRow(icon: Icons.email, label: "Email", value: _userData?["email"] ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.cake, label: "Data de Nascimento", value: _userData?["birthDate"] ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.phone, label: "Contato", value: _userData?["contact"] ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.wc, label: "Gênero", value: _userData?["gender"] ?? ""),
                            const Divider(height: 32),
                            InfoRow(icon: Icons.health_and_safety, label: "Associação/Classe", value: _userData?["association"] ?? ""),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}