import 'package:flutter/material.dart';
import 'package:frontend/core/state/adherence_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/models/adherence_history_model.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
    await context.read<AdherenceProvider>().loadLast30Days(
      userId: _selectedMemberId,
    );
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  Color _rateColor(double rate) {
    if (rate >= 80) return AppColors.primary;
    if (rate >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdherenceProvider>();
    final userProvider = context.watch<UserProvider>();
    final memberProvider = context.watch<MemberProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico'), centerTitle: true),
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

          if (!provider.isLoading && provider.history.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Últimos 30 dias',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SummaryItem(
                        label: 'Adesão média',
                        value:
                            '${provider.averageAdherenceRate.toStringAsFixed(0)}%',
                        color: _rateColor(provider.averageAdherenceRate),
                      ),
                      SummaryItem(
                        label: 'Tomadas',
                        value: provider.totalTaken.toString(),
                        color: AppColors.primary,
                      ),
                      SummaryItem(
                        label: 'Perdidas',
                        value: provider.totalMissed.toString(),
                        color: Colors.red,
                      ),
                      SummaryItem(
                        label: 'Atrasadas',
                        value: provider.totalDelayed.toString(),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_outlined,
                          size: 64,
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum histórico ainda',
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'As doses confirmadas aparecem\nautomaticamente no histórico',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: provider.history.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = provider.history[index];
                      return _HistoryCard(
                        history: item,
                        formattedDate: _formatDate(item.date),
                        rateColor: _rateColor(item.adherenceRate),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Card de histórico por dia ──
class _HistoryCard extends StatelessWidget {
  final AdherenceHistoryModel history;
  final String formattedDate;
  final Color rateColor;

  const _HistoryCard({
    required this.history,
    required this.formattedDate,
    required this.rateColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Data
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    formattedDate.substring(0, 5), // dd/MM
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    formattedDate.substring(6), // yyyy
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Doses
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _DoseBadge(
                        label: '${history.takenDoses} tomadas',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      if (history.missedDoses > 0)
                        _DoseBadge(
                          label: '${history.missedDoses} perdidas',
                          color: Colors.red,
                        ),
                      if (history.delayedDoses > 0) ...[
                        const SizedBox(width: 6),
                        _DoseBadge(
                          label: '${history.delayedDoses} atrasadas',
                          color: Colors.orange,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Barra de progresso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: history.adherenceRate / 100,
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.1,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Taxa de adesão
            Text(
              '${history.adherenceRate.toStringAsFixed(0)}%',
              style: TextStyle(
                color: rateColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _DoseBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
