import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/state/adherence_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/medication_provider.dart';
import 'package:frontend/core/state/schedule_provider.dart';
import 'package:frontend/features/alarm/screen/alarm_screen.dart';
import 'package:frontend/features/service/alarm_service.dart';
import 'package:frontend/features/service/notification_service.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/routes.dart';
import 'core/state/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AlarmService.initialize();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.systemAlertWindow.request();

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  @override
  void initState() {
    super.initState();

    print('APP INICIADO');

    _requestPermissions();

    Alarm.ringing.listen((alarmSet) {
      print('ALARME RECEBIDO');
      print('Quantidade: ${alarmSet.alarms.length}');
      print('Navigator: ${navigatorKey.currentState}');

      for (final alarm in alarmSet.alarms) {
        print('Alarme ID: ${alarm.id}');

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AlarmScreen(alarmSettings: alarm),
          ),
        );
      }
    });
  }

  // This widget is the root of your application.
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
