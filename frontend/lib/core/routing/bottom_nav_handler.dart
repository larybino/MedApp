import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';

class BottomNavHandler {
  static void navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;

      case 1:
        context.go(Routes.medications);
        break;

      case 2:
        context.push(Routes.createMedication);
        break;

      case 3:
        context.go(Routes.schedule);
        break;

      case 4:
        context.go(Routes.settings);
        break;
    }
  }
}
