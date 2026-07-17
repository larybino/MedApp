import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/index.dart';
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
  bool _notificationsEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await NotificationPreferences.getNotificationsEnabled();
    final onlyMine = await NotificationPreferences.getOnlyMyDoses();
    if (mounted) {
      setState(() {
        _notificationsEnabled = enabled;
        _onlyMyDoses = onlyMine;
        _loading = false;
      });
    }
  }

  Future<void> _onToggleEnabled(bool value) async {
    setState(() => _notificationsEnabled = value);
    await NotificationPreferences.setNotificationsEnabled(value);
  }

  Future<void> _onToggleOnlyMine(bool value) async {
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
                const SizedBox(height: 16),
                Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: ToggleRow(
                      title: 'Receber notificações',
                      subtitle:
                          'Ativa lembretes de dose e alertas de estoque baixo neste aparelho',
                      value: _notificationsEnabled,
                      onChanged: _onToggleEnabled,
                    ),
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
                      child: Opacity(
                        opacity: _notificationsEnabled ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: !_notificationsEnabled,
                          child: ToggleRow(
                            title: 'Notificar apenas minhas doses',
                            subtitle:
                                'Quando desativado, você também recebe notificações '
                                'dos perfis vinculados a você',
                            value: _onlyMyDoses,
                            onChanged: _onToggleOnlyMine,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
