import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';

class BottomNavHandler {
  static void navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;

      case 1:
        context.go(Routes.medications);
        break;
      
      case 2:
        context.go(Routes.createMedication);
        break;

      case 3:
        break;

      case 4:
        context.go(Routes.settings);
        break;
    }
  }
}