import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';

class ScheduleDoseCard extends StatelessWidget {
  final ScheduledDoseModel dose;
  final String formattedTime;
  final VoidCallback? onToggle;

  const ScheduleDoseCard({
    required this.dose,
    required this.formattedTime,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isTaken = dose.doseStatus == 'TAKEN';
    final isMissed = dose.doseStatus == 'MISSED';

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
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        child: Row(
          children: [

            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dose.medicationName,
                    style: TextStyle(
                      color: isMissed
                          ? AppColors.secondary.withValues(alpha: 0.4)
                          : AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      decoration: isMissed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Toggle
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isTaken
                      ? AppColors.primary
                      : isMissed
                          ? Colors.grey.withValues(alpha: 0.3)
                          : AppColors.secondary.withValues(alpha: 0.2),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: isTaken
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isMissed
                          ? Colors.grey.withValues(alpha: 0.5)
                          : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}