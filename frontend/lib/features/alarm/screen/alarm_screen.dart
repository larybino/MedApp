import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/state/schedule_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmScreen({
    super.key,
    required this.alarmSettings,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _stopAlarm() async {
    await Alarm.stop(widget.alarmSettings.id);

    if (!mounted) return;

    final tomou = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar dose'),
        content: Text('Você já tomou o medicamento da vez?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ainda não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text(
              'Sim, tomei!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (tomou == true) {
      try {
        await context.read<ScheduleProvider>().confirmDose(widget.alarmSettings.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dose confirmada com sucesso!')),
          );
          Navigator.pop(context); 
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao confirmar: $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context); 
        }
      }
    } else {
      await _snooze();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alarme adiado para daqui a 10 minutos')),
        );
      }
    }
  }

  Future<void> _snooze() async {
    await Alarm.stop(widget.alarmSettings.id);

    final snoozeTime = DateTime.now().add(
      const Duration(minutes: 10),
    );

    await Alarm.set(
      alarmSettings: widget.alarmSettings.copyWith(
        dateTime: snoozeTime,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      size: 72,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  _formatTime(widget.alarmSettings.dateTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Text(
                  widget.alarmSettings.notificationSettings.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.alarmSettings.notificationSettings.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 56),

                TextButton.icon(
                  onPressed: _snooze,
                  icon: const Icon(
                    Icons.snooze,
                    color: Colors.white70,
                  ),
                  label: const Text(
                    'Soneca (10 min)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                GestureDetector(
                  onTap: _stopAlarm,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          blurRadius: 24,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.stop_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Parar alarme',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}