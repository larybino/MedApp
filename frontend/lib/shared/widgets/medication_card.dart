import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/models/medication_model.dart';
import 'package:frontend/shared/widgets/info_chip.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;
  final String intervalLabel;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;
  final VoidCallback onEndTreatment;
  final VoidCallback onEdit;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.intervalLabel,
    required this.onDelete,
    required this.onConfirm,
    required this.onEndTreatment,
    required this.onEdit,
  });

  Color _statusColor() {
    switch (medication.scheduleStatus) {
      case 'ACTIVE':
        return AppColors.primary;
      case 'PAUSED':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  String _statusLabel() {
    switch (medication.scheduleStatus) {
      case 'ACTIVE':
        return 'Ativo';
      case 'PAUSED':
        return 'Pausado';
      case 'COMPLETED':
        return 'Concluído';
      default:
        return 'Cancelado';
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: medication.medicationImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64Decode(medication.medicationImage!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.medication_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medication.dosage,
                        style: TextStyle(
                          color: AppColors.secondary.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                InfoChip(
                  icon: Icons.access_time,
                  label: intervalLabel,
                ),
                InfoChip(
                  icon: Icons.circle,
                  label: _statusLabel(),
                  color: _statusColor(),
                ),
                if (medication.currentStock != null)
                  InfoChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Estoque: ${medication.currentStock}',
                    color: medication.currentStock! <= 5
                        ? Colors.orange
                        : AppColors.secondary,
                  ),
              ],
            ),
            if (!medication.acquisitionConfirmed ||
                medication.scheduleStatus == 'ACTIVE')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (!medication.acquisitionConfirmed)
                      TextButton.icon(
                        onPressed: onConfirm,
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                        ),
                        label: const Text('Confirmar aquisição'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    if (medication.scheduleStatus == 'ACTIVE')
                      TextButton.icon(
                        onPressed: onEndTreatment,
                        icon: const Icon(Icons.flag_outlined, size: 16),
                        label: const Text('Finalizar tratamento'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

