import 'package:flutter/foundation.dart';
import 'package:frontend/core/storage/secure_storage.dart';
import 'package:frontend/features/models/user_model.dart';
import 'package:frontend/features/service/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({UserService? userService})
      : _userService = userService ?? UserService();

  final UserService _userService;
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  bool get isMaster => user?.role == 'MASTER';
  bool get isMember => user?.role == 'MEMBER';

  Future<void> loadUser({bool force = false}) async {
    if (_user != null && !force) {
      return;
    }
    final userId = await SecureStorage.getUserId();
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }
    _setLoading(true);
    try {
      _user = await _userService.getProfile(userId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshUser() async {
    await loadUser(force: true);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
