import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';

class BottomNavHandler {
  static void navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;

      case 1:
        break;

      case 2:
        break;

      case 3:
        break;

      case 4:
        context.go(Routes.settings);
        break;
    }
  }
}