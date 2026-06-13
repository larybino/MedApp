import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';

class DoseCard extends StatelessWidget {
  final ScheduledDoseModel dose;
  final String formattedTime;
  final VoidCallback? onConfirm;

  const DoseCard({
    super.key,
    required this.dose,
    required this.formattedTime,
    this.onConfirm,
  });

  Color _statusColor() {
    switch (dose.doseStatus) {
      case 'TAKEN': return AppColors.primary;
      case 'MISSED': return Colors.red;
      case 'DELAYED': return Colors.orange;
      default: return AppColors.secondary.withValues(alpha: 0.6);
    }
  }

  IconData _statusIcon() {
    switch (dose.doseStatus) {
      case 'TAKEN': return Icons.check_circle_rounded;
      case 'MISSED': return Icons.cancel_rounded;
      case 'DELAYED': return Icons.watch_later_rounded;
      default: return Icons.radio_button_unchecked_rounded;
    }
  }

  String _statusLabel() {
    switch (dose.doseStatus) {
      case 'TAKEN': return 'Tomado';
      case 'MISSED': return 'Perdido';
      case 'DELAYED': return 'Atrasado';
      default: return 'Pendente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = dose.doseStatus == 'PENDING';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: isPending && dose.withinWindow
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [

            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: AppColors.primary),
                  const SizedBox(height: 2),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
                  Text(
                    dose.medicationName,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dose.dosage,
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // badge de janela ativa
                  if (isPending && dose.withinWindow)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Dentro da janela',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(_statusIcon(),
                        color: _statusColor(), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel(),
                      style: TextStyle(
                        color: _statusColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (onConfirm != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Tomei',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}