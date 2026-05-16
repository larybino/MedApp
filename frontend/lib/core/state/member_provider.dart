import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage.dart';
import 'package:frontend/features/models/user_model.dart';
import 'package:frontend/features/service/user_service.dart';

class MemberProvider extends ChangeNotifier {
  final UserService _service = UserService();

  List<UserModel> _members = [];
  bool _isLoading = false;

  List<UserModel> get members => _members;
  bool get isLoading => _isLoading;

  Future<void> loadMembers() async {
    final masterId = await SecureStorage.getUserId();
    if (masterId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _members = await _service.getMembers(masterId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMember({
      required String mode,
      String? name,
      String? email,
      String? password,
      String? memberCode,
    }) async {
      final masterId = await SecureStorage.getUserId();
      if (masterId == null) return;

      await _service.createMember(
        masterId: masterId,
        mode: mode,
        name: name,
        email: email,
        password: password,
        memberCode: memberCode,
      );
      await loadMembers();
    }

  Future<void> removeMember(int memberId) async {
    final masterId = await SecureStorage.getUserId();
    if (masterId == null) return;

    await _service.removeMember(masterId, memberId);
    await loadMembers(); 
  }
}