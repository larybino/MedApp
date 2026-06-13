import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../core/utils/input_utils.dart';
import '../../core/theme/app_colors.dart';

class ImagePickerCard extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageBase64;
  final VoidCallback onTap;

  const ImagePickerCard({
    super.key,
    required this.imageBytes,
    required this.imageBase64,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = imageBytes ?? InputUtils.decodeBase64Image(imageBase64);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
          image: bytes != null
              ? DecorationImage(
                  image: MemoryImage(bytes),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: bytes == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 36, color: AppColors.primary.withValues(alpha: 0.6)),
                  const SizedBox(height: 8),
                  Text(
                    'Adicionar foto do medicamento',
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
      ),
    );
  }
}