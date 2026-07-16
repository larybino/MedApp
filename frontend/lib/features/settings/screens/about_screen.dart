import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = '${info.version} (build ${info.buildNumber})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre nós'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Icon(Icons.medication, size: 72, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'MedApp',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 4),
            if (_version.isNotEmpty)
              Text(
                'Versão $_version',
                style: TextStyle(
                  color: AppColors.secondary.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'O MedApp é um aplicativo de gerenciamento de medicamentos, '
              'desenvolvido para ajudar pacientes e cuidadores a organizar '
              'horários de dose, controlar estoque e acompanhar a adesão '
              'ao tratamento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondary, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'Desenvolvido por Laryssa Bino\ncomo Trabalho de Conclusão de Curso — IFPR Paranavaí',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondary.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
