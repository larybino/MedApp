import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/index.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * 0.97 > 500 ? 500 : width * 0.97,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Nome',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Data de Nascimento',
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Contato',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Gênero',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Classe/Associação',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.04),
                PrimaryButton(
                  label: 'Salvar Alterações',
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
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