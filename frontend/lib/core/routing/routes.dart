import 'package:flutter/material.dart';
import 'package:frontend/features/medication/screens/create_medication_screen.dart';
import 'package:frontend/features/medication/screens/medication_list_screen.dart';
import 'package:frontend/features/members/screens/create_members_screen.dart';
import 'package:frontend/features/members/screens/members_screen.dart';
import 'package:frontend/features/user/screens/change_password_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/auth/screens/forgot_password_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import 'package:frontend/features/auth/screens/reset_password_screen.dart';
import 'package:frontend/features/auth/screens/splash_screen.dart';
import 'package:frontend/features/settings/screens/settings_screen.dart';
import 'package:frontend/features/user/screens/edit_user_screen.dart';
import 'package:frontend/features/user/screens/user_profile_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';
  static const String userProfile = '/user-profile';
  static const String editUser = '/edit-user';
  static const String settings = '/settings';
  static const String members = '/members';
  static const String createMember = '/members/create';
  static const String medications = '/medications';
  static const String createMedication = '/medications/create';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // GoRoute(
      //   path: home,
      //   // builder: (context, state) => const HomeScreen(),
      // ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: userProfile,
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: editUser,
        builder: (context, state) => const EditUserScreen(),
      ),
      GoRoute(
        path: members,
        builder: (context, state) => const MembersScreen(),
      ),
      GoRoute(
        path: createMember,
        builder: (context, state) => const CreateMemberScreen(),
      ),
      GoRoute(
        path: medications,
        builder: (context, state) => const MedicationListScreen(),
      ),
      GoRoute(
        path: createMedication,
        builder: (context, state) => const CreateMedicationScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Rota desconhecida: ${state.uri.path}')),
    ),
  );
}
