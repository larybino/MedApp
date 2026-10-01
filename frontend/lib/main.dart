import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/routing/alarm_navigator.dart';
import 'package:frontend/core/state/adherence_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/medication_provider.dart';
import 'package:frontend/core/state/schedule_provider.dart';
import 'package:frontend/core/storage/alarm_reliability_preferences.dart';
import 'package:frontend/features/service/alarm_launch_service.dart';
import 'package:frontend/features/service/alarm_reliability_service.dart';
import 'package:frontend/features/service/alarm_service.dart';
import 'package:frontend/features/service/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/navigator_key.dart';
import 'core/routing/routes.dart';
import 'core/state/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await AlarmService.initialize();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> _requestPermissions() async {
    await AlarmReliabilityService.requestBasicPermissions();
  }

 Future<void> _maybeShowAlarmReliabilityPrompt() async {
    final alreadyAsked = await AlarmReliabilityPreferences.getAlreadyAsked();
    if (alreadyAsked) return;

    await Future.delayed(const Duration(seconds: 2));
    final dialogContext = navigatorKey.currentContext;
    if (dialogContext == null || !dialogContext.mounted) return;

    await showDialog<void>(
      context: dialogContext,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Alarmes mais confiáveis'),
        content: const Text(
          'Alguns celulares bloqueiam esse tipo de alarme por padrão, o '
          'que pode fazer a tela do remédio não abrir sozinha na hora '
          'certa. Vamos te levar a algumas telas de configuração rápidas '
          'pra evitar isso — é só confirmar em cada uma.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Agora não'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AlarmReliabilityService.requestNow();
            },
            child: const Text('Liberar'),
          ),
        ],
      ),
    );

    await AlarmReliabilityPreferences.setAlreadyAsked();
  }

  Future<void> _checkPendingAlarmLaunch() async {
    final alarmId = await AlarmLaunchService.consumePendingAlarmId();
    if (alarmId == null) return;

    final alarm = await Alarm.getAlarm(alarmId);
    if (alarm == null) return;

    AlarmNavigator.showAlarmScreen(alarm);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPendingAlarmLaunch();
      navigatorKey.currentContext
          ?.read<ScheduleProvider>()
          .syncPendingConfirmations();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _requestPermissions();
    _maybeShowAlarmReliabilityPrompt();
    Future.delayed(const Duration(seconds: 1), () {
      Alarm.ringing.listen((alarmSet) {
        for (final alarm in alarmSet.alarms) {
          AlarmNavigator.showAlarmScreen(alarm);
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => AdherenceProvider()),
      ],
      child: MaterialApp.router(
        title: 'MedApp',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: Routes.router,
      ),
    );
  }
}