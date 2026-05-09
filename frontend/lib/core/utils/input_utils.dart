import 'dart:convert';
import 'dart:typed_data';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputUtils {
  static const Map<String, String> genderLabelByValue = {
    'FEMALE': 'Feminino',
    'MALE': 'Masculino',
    'OTHER': 'Outro',
  };

  static const Map<String, String> genderValueByLabel = {
    'Feminino': 'FEMALE',
    'Masculino': 'MALE',
    'Outro': 'OTHER',
  };

  static const List<String> genderOptions = [
    'Feminino',
    'Masculino',
    'Outro',
  ];

  static String genderLabelFromValue(String? value) {
    if (value == null) {
      return '';
    }
    return genderLabelByValue[value] ?? value;
  }

  static String genderValueFromLabel(String? label) {
    if (label == null) {
      return '';
    }
    return genderValueByLabel[label] ?? label;
  }

  static MaskTextInputFormatter birthDateMask() {
    return MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {'#': RegExp(r'[0-9]')},
    );
  }

  static MaskTextInputFormatter phoneMask() {
    return MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {'#': RegExp(r'[0-9]')},
    );
  }
  
  static String formatBirthDateForDisplay(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }

  static String? normalizeBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    final parsedIso = DateTime.tryParse(trimmed);
    if (parsedIso != null) {
      return _formatDateIso(parsedIso);
    }
    final parts = trimmed.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return _formatDateIso(DateTime(year, month, day));
      }
    }
    return trimmed;
  }

  static String _formatDateIso(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

    static Uint8List? decodeBase64Image(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    final normalized = trimmed.startsWith('data:image')
        ? trimmed.split(',').last
        : trimmed;
    try {
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }
}
