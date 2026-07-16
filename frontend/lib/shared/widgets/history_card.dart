import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/models/adherence_history_model.dart';
import 'dose_badge.dart';

class HistoryCard extends StatelessWidget {
  final AdherenceHistoryModel history;
  final String formattedDate;
  final Color rateColor;

  const HistoryCard({
    super.key,
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
                    formattedDate.substring(0, 5),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    formattedDate.substring(6),
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      DoseBadge(
                        label: '${history.takenDoses} tomadas',
                        color: AppColors.primary,
                      ),
                      if (history.missedDoses > 0)
                        DoseBadge(
                          label: '${history.missedDoses} perdidas',
                          color: Colors.red,
                        ),
                      if (history.delayedDoses > 0)
                        DoseBadge(
                          label: '${history.delayedDoses} atrasadas',
                          color: Colors.orange,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
