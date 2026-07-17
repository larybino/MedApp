import 'package:flutter/material.dart';
import 'package:frontend/core/routing/bottom_nav_handler.dart';
import 'package:frontend/core/state/medication_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medication/screens/create_medication_screen.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  int? _selectedMemberId;

  Future<void> _onRefresh() async {
    await _reload();
    if (context.read<UserProvider>().isMaster) {
      await context.read<MemberProvider>().loadMembers();
    }
    await context.read<MedicationProvider>().checkLowStockAlerts();
  }

  Future<void> _initializeScreen() async {
    final userProvider = context.read<UserProvider>();
    final medicationProvider = context.read<MedicationProvider>();
    final memberProvider = context.read<MemberProvider>();

    await userProvider.loadUser();
    await medicationProvider.loadMedications(userId: _selectedMemberId);
    await medicationProvider.checkLowStockAlerts();

    if (userProvider.isMaster) {
      await memberProvider.loadMembers();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeScreen();
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
        await context.read<MedicationProvider>().deleteMedication(
          id,
          userId: _selectedMemberId,
        );
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

  Future<void> _showRestockDialog(int id, String name) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final quantity = await showDialog<double>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.warning,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Repor estoque',
                  style: GoogleFonts.syne(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Quantas unidades de "$name" você repôs?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Quantidade reposta',
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(
                      value?.replaceAll(',', '.') ?? '',
                    );
                    if (parsed == null || parsed <= 0) {
                      return 'Informe uma quantidade válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Confirmar',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final parsed = double.parse(
                        controller.text.replaceAll(',', '.'),
                      );
                      Navigator.pop(context, parsed);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary.withValues(alpha: 0.6),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (quantity != null && mounted) {
      try {
        await context.read<MedicationProvider>().restockMedication(
          id,
          quantity,
          userId: _selectedMemberId,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Estoque reposto com sucesso!')),
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
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: provider.medications.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              const SizedBox(height: 120),
                              Icon(
                                Icons.medication_outlined,
                                size: 64,
                                color: AppColors.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum medicamento cadastrado',
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
                            itemCount: provider.medications.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final med = provider.medications[index];
                              return MedicationCard(
                                medication: med,
                                intervalLabel: _intervalLabel(med.doseInterval),
                                onDelete: () =>
                                    _confirmDelete(med.id, med.name),
                                onRestock: () =>
                                    _showRestockDialog(med.id, med.name),
                                onConfirm: () async {
                                  if (!mounted) return;
                                  final result =
                                      await Navigator.push<
                                        Map<String, dynamic>
                                      >(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CreateMedicationScreen(
                                                initialMedication: med,
                                                confirmAcquisitionMode: true,
                                              ),
                                        ),
                                      );
                                  if (result?['success'] == true && mounted) {
                                    _reload();
                                  }
                                },
                                onEndTreatment: () async {
                                  try {
                                    await context
                                        .read<MedicationProvider>()
                                        .endTreatment(
                                          med.id,
                                          userId: _selectedMemberId,
                                        );
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                  final result =
                                      await Navigator.push<
                                        Map<String, dynamic>
                                      >(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CreateMedicationScreen(
                                                initialMedication: med,
                                              ),
                                        ),
                                      );
                                  if (result?['success'] == true && mounted) {
                                    _reload();
                                  }
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await context.read<MemberProvider>().loadMembers();
          if (mounted) {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(
                builder: (_) => CreateMedicationScreen(
                  initialTargetUserId: _selectedMemberId,
                ),
              ),
            );
            if (result?['success'] == true && mounted) {
              setState(() {
                _selectedMemberId = result?['targetUserId'] as int?;
              });
              _reload();
            }
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
