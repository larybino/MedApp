import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/medication_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medication/screens/create_medication_screen.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  int? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = _selectedMemberId;
      await context.read<MedicationProvider>().loadMedications(userId: userId);
      await context.read<MedicationProvider>().checkLowStockAlerts();
      if (context.read<UserProvider>().isMaster) {
        await context.read<MemberProvider>().loadMembers();
      }
    });
  }

  Future<void> _reload() async {
    await context.read<MedicationProvider>().loadMedications(
      userId: _selectedMemberId,
    );
  }

  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover medicamento'),
        content: Text('Deseja remover "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<MedicationProvider>().deleteMedication(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medicamento removido com sucesso!')),
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

  String _intervalLabel(String interval) {
    switch (interval) {
      case 'FOUR_HOURS':
        return 'A cada 4h';
      case 'SIX_HOURS':
        return 'A cada 6h';
      case 'EIGHT_HOURS':
        return 'A cada 8h';
      case 'TWELVE_HOURS':
        return 'A cada 12h';
      case 'TWENTY_FOUR_HOURS':
        return '1x ao dia';
      default:
        return 'Horário fixo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicationProvider>();
    final userProvider = context.watch<UserProvider>();
    final memberProvider = context.watch<MemberProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Remédios'), centerTitle: true),
      body: Column(
        children: [
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
                : provider.medications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 64,
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum medicamento cadastrado',
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
                    itemCount: provider.medications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final med = provider.medications[index];
                      return MedicationCard(
                        medication: med,
                        intervalLabel: _intervalLabel(med.doseInterval),
                        onDelete: () => _confirmDelete(med.id, med.name),
                        onConfirm: () async {
                          if (!mounted) return;
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateMedicationScreen(
                                initialMedication: med,
                                confirmAcquisitionMode: true,
                              ),
                            ),
                          );
                          if (updated == true && mounted) _reload();
                        },
                        onEndTreatment: () async {
                          try {
                            await context
                                .read<MedicationProvider>()
                                .endTreatment(med.id);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        onEdit: () async {
                          if (!mounted) return;
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateMedicationScreen(
                                initialMedication: med,
                              ),
                            ),
                          );
                          if (updated == true && mounted) {
                            _reload();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await context.read<MemberProvider>().loadMembers();
          if (mounted) {
            final created = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const CreateMedicationScreen()),
            );
            if (created == true && mounted) _reload();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onTap: (index) => BottomNavHandler.navigate(context, index),
      ),
    );
  }
}
