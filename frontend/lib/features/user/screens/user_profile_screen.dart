import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:frontend/shared/widgets/custom_floating_action_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

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
        onPressed: () {},
      ),
      body: SingleChildScrollView(
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
                        "Nome do Usuário",
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
                      InfoRow(icon: Icons.email, label: "Email", value: "email@email.com"),
                      const Divider(height: 32),
                      InfoRow(icon: Icons.cake, label: "Data de Nascimento", value: "01/01/2000"),
                      const Divider(height: 32),
                      InfoRow(icon: Icons.phone, label: "Contato", value: "+55 (44) 99999-9999"),
                      const Divider(height: 32),
                      InfoRow(icon: Icons.wc, label: "Gênero", value: "Feminino"),
                      const Divider(height: 32),
                      InfoRow(icon: Icons.health_and_safety, label: "Associação/Classe", value: "Exemplo"),
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
        onTap: (index) {
        },
      ),
    );
  }
}