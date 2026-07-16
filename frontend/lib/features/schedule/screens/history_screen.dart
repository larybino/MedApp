import 'package:flutter/material.dart';
import 'package:frontend/core/state/adherence_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
                      return HistoryCard(
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
