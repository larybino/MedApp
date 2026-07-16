import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/user_provider.dart';
import '../../../core/storage/notification_preferences.dart';
import '../../../core/theme/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _onlyMyDoses = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await NotificationPreferences.getOnlyMyDoses();
    if (mounted) {
      setState(() {
        _onlyMyDoses = value;
        _loading = false;
      });
    }
  }

  Future<void> _onChanged(bool value) async {
    setState(() => _onlyMyDoses = value);
    await NotificationPreferences.setOnlyMyDoses(value);
  }

  @override
  Widget build(BuildContext context) {
    final isMaster = context.watch<UserProvider>().isMaster;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificações'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.alarm,
                          color: AppColors.secondary,
                        ),
                        title: const Text('Lembretes de dose'),
                        subtitle: const Text(
                          'Avisos para confirmar se você tomou o medicamento',
                        ),
                        textColor: AppColors.secondary,
                      ),
                      const Divider(height: 1, color: AppColors.lightGrey),
                      ListTile(
                        leading: const Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.secondary,
                        ),
                        title: const Text('Alerta de estoque baixo'),
                        subtitle: const Text(
                          'Aviso quando o estoque de um medicamento está acabando',
                        ),
                        textColor: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
                if (isMaster) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notificar apenas minhas doses',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quando desativado, você também recebe notificações '
                                  'dos perfis vinculados a você',
                                  style: TextStyle(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _onChanged(!_onlyMyDoses),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 52,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _onlyMyDoses
                                    ? AppColors.primary
                                    : AppColors.secondary.withValues(
                                        alpha: 0.2,
                                      ),
                              ),
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 200),
                                alignment: _onlyMyDoses
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
