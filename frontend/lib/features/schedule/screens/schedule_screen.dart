import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/schedule_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _reload();
      if (context.read<UserProvider>().isMaster) {
        await context.read<MemberProvider>().loadMembers();
      }
    });
  }

  Future<void> _reload() async {
    final date =
        '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}';
    await context.read<ScheduleProvider>().loadDosesByDate(
      date,
      userId: _selectedMemberId,
    );
  }

  Future<void> _confirmDose(int doseId, String medicationName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar dose'),
        content: Text('Confirmar que tomou "$medicationName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Confirmar',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ScheduleProvider>().confirmDose(doseId);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Dose confirmada!')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String _formatTime(String time) =>
      time.length >= 5 ? time.substring(0, 5) : time;

  String _formatHeaderDate(DateTime date) {
    const weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final userProvider = context.watch<UserProvider>();
    final memberProvider = context.watch<MemberProvider>();

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com data selecionada
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Text(
                      _formatHeaderDate(_selectedDay),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  TableCalendar(
                    locale: 'pt_BR',
                    firstDay: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _reload();
                    },
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mês',
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                      // dia selecionado
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      // hoje
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      todayTextStyle: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      // outros dias
                      defaultTextStyle: const TextStyle(color: Colors.white70),
                      weekendTextStyle: const TextStyle(color: Colors.white70),
                      outsideTextStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.primary,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                      ),
                      titleTextStyle: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          if (userProvider.isMaster && memberProvider.members.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppChip.selectable(
                      label: 'Eu',
                      isSelected: _selectedMemberId == null,
                      onTap: () {
                        setState(() => _selectedMemberId = null);
                        _reload();
                      },
                    ),
                    const SizedBox(width: 8),
                    ...memberProvider.members.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AppChip.selectable(
                          label: m.name,
                          isSelected: _selectedMemberId == m.id,
                          onTap: () {
                            setState(() => _selectedMemberId = m.id);
                            _reload();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.doses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available_outlined,
                          size: 64,
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma dose para este dia',
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.doses.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final dose = provider.doses[index];
                      return ScheduleDoseCard(
                        dose: dose,
                        formattedTime: _formatTime(dose.scheduledTime),
                        onToggle:
                            (dose.doseStatus == 'PENDING' ||
                                dose.doseStatus == 'MISSED')
                            ? () => _confirmDose(dose.id, dose.medicationName)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 3,
        onTap: (index) => BottomNavHandler.navigate(context, index),
      ),
    );
  }
}
