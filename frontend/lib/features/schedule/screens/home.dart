import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/schedule_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int? _selectedMemberId;
  String? _statusFilter;
  bool _isInitializing = true;
  String? _initError;

  void _toggleStatusFilter(String status) {
    setState(() {
      _statusFilter = _statusFilter == status ? null : status;
    });
  }

  Future<void> _initializeScreen() async {
    final userProvider = context.read<UserProvider>();
    final memberProvider = context.read<MemberProvider>();

    await userProvider.loadUser();
    await _reload();

    if (userProvider.isMaster) {
      await memberProvider.loadMembers();
    }

    await context.read<ScheduleProvider>().syncNotifications(
      isMaster: userProvider.isMaster,
      memberIds: memberProvider.members.map((m) => m.id).toList(),
    );
  }

  Future<void> _onRefresh() async {
    try {
      await _initializeScreen();
      if (mounted) setState(() => _initError = null);
    } catch (e) {
      if (mounted) setState(() => _initError = e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runInitialization());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 800), _runInitialization);
    }
  }

  Future<void> _runInitialization() async {
    if (mounted) setState(() => _isInitializing = true);
    try {
      await _initializeScreen();
      if (mounted) setState(() => _initError = null);
    } catch (e) {
      if (mounted) {
        setState(() => _initError = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  Future<void> _reload() async {
    await context.read<ScheduleProvider>().loadTodayDoses(
      userId: _selectedMemberId,
    );
  }

  Future<void> _confirmDose(int doseId, String medicationName) async {
    final isLate =
        context
            .read<ScheduleProvider>()
            .doses
            .firstWhere((d) => d.id == doseId)
            .doseStatus ==
        'MISSED';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar dose'),
        content: Text(
          isLate
              ? 'Esta dose foi marcada como perdida. Deseja registrar que tomou atrasado?'
              : 'Confirmar que tomou "$medicationName"?',
        ),
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
        await context.read<ScheduleProvider>().confirmDose(
          doseId,
          userId: _selectedMemberId,
        );
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

  Future<void> _unconfirmDose(int doseId, String medicationName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desfazer confirmação'),
        content: Text('Marcar "$medicationName" como não tomada novamente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Desfazer',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ScheduleProvider>().unconfirmDose(
          doseId,
          userId: _selectedMemberId,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Confirmação desfeita.')),
          );
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

  String _formatTime(String time) {
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final userProvider = context.watch<UserProvider>();
    final memberProvider = context.watch<MemberProvider>();
    final now = DateTime.now();
    final dateLabel =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final displayedDoses = _statusFilter == null
        ? provider.doses
        : provider.doses.where((d) => d.doseStatus == _statusFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoje'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                dateLabel,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!provider.isLoading && provider.doses.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SummaryItem(
                    label: 'Total',
                    value: provider.doses.length.toString(),
                    color: AppColors.secondary,
                    isSelected: _statusFilter == null,
                    onTap: () => setState(() => _statusFilter = null),
                  ),
                  SummaryItem(
                    label: 'Tomadas',
                    value: provider.takenDoses.length.toString(),
                    color: AppColors.primary,
                    isSelected: _statusFilter == 'TAKEN',
                    onTap: () => _toggleStatusFilter('TAKEN'),
                  ),
                  SummaryItem(
                    label: 'Atrasadas',
                    value: provider.delayedDoses.length.toString(),
                    color: Colors.orange,
                    isSelected: _statusFilter == 'DELAYED',
                    onTap: () => _toggleStatusFilter('DELAYED'),
                  ),
                  SummaryItem(
                    label: 'Perdidas',
                    value: provider.missedDoses.length.toString(),
                    color: Colors.red,
                    isSelected: _statusFilter == 'MISSED',
                    onTap: () => _toggleStatusFilter('MISSED'),
                  ),
                ],
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
                        setState(() {
                          _selectedMemberId = null;
                          _statusFilter = null;
                        });
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
                            setState(() {
                              _selectedMemberId = m.id;
                              _statusFilter = null;
                            });
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
            child: (_isInitializing || provider.isLoading)
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Carregando seus medicamentos...',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  )
                : ((_initError != null || provider.loadError != null) &&
                      displayedDoses.isEmpty)
                ? RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(height: 100),
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 64,
                          color: AppColors.danger,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Não foi possível carregar seus medicamentos agora.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Isso costuma acontecer quando o servidor '
                          'estava inativo há um tempo. Puxe pra baixo '
                          'ou toque no botão para tentar de novo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: _onRefresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: displayedDoses.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              const SizedBox(height: 120),
                              Icon(
                                Icons.check_circle_outline,
                                size: 64,
                                color: AppColors.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _statusFilter == null
                                    ? 'Nenhum medicamento para hoje'
                                    : 'Nenhum medicamento com esse status',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: displayedDoses.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final dose = displayedDoses[index];
                              final isConfirmed =
                                  dose.doseStatus == 'TAKEN' ||
                                  dose.doseStatus == 'DELAYED';
                              return DoseCard(
                                dose: dose,
                                formattedTime: _formatTime(dose.scheduledTime),
                                onConfirm:
                                    (dose.doseStatus == 'PENDING' ||
                                        dose.doseStatus == 'MISSED')
                                    ? () => _confirmDose(
                                        dose.id,
                                        dose.medicationName,
                                      )
                                    : null,
                                onUndo: isConfirmed
                                    ? () => _unconfirmDose(
                                        dose.id,
                                        dose.medicationName,
                                      )
                                    : null,
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (index) => BottomNavHandler.navigate(context, index),
      ),
    );
  }
}