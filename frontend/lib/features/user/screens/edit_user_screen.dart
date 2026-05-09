import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/routing/routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/storage/secure_storage.dart';
import 'package:frontend/core/utils/input_utils.dart';
import 'package:frontend/features/service/user_service.dart';
import 'package:frontend/shared/widgets/index.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _pictureProfileController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _associationController = TextEditingController();
  final _userService = UserService();
  final _imagePicker = ImagePicker();
  Uint8List? _profileImageBytes;
  final _birthDateMask = InputUtils.birthDateMask();
  final _phoneMask = InputUtils.phoneMask();
  final List<String> _genderOptions = InputUtils.genderOptions;
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }
      setState(() => _userId = userId);
      
      final userData = await _userService.getProfile(userId);
      setState(() {
        _nameController.text = userData.name;
        _emailController.text = userData.email;
        _birthDateController.text = InputUtils.formatBirthDateForDisplay(userData.birthDate);
        _phoneController.text = userData.phone ?? '';
        _genderController.text = InputUtils.genderLabelFromValue(userData.gender);
        _associationController.text = userData.association ?? '';
        _pictureProfileController.text = userData.profilePicture ?? '';
        _profileImageBytes = InputUtils.decodeBase64Image(userData.profilePicture);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ErrorMessage.show(context, e.toString());
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ErrorMessage.show(context, 'Preencha os campos obrigatórios');
      return;
    }
    
    if (_userId == null) {
      ErrorMessage.show(context, 'Erro: Usuário não identificado');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final normalizedBirthDate = InputUtils.normalizeBirthDate(_birthDateController.text);
      final genderValue = InputUtils.genderValueFromLabel(_genderController.text);
      await _userService.updateProfile(
        _userId!,
        {
          'profilePicture': _pictureProfileController.text,
          'name': _nameController.text,
          'email': _emailController.text,
          'birthDate': normalizedBirthDate,
          'phone': _phoneController.text,
          'gender': genderValue,
          'association': _associationController.text,
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alterações salvas com sucesso!')),
        );
        context.go(Routes.userProfile);
      }
    } catch (e) {
      if (mounted) {
        ErrorMessage.show(context, 'Erro ao salvar alterações: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _associationController.dispose();
    _pictureProfileController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _profileImageBytes = bytes;
      _pictureProfileController.text = base64Encode(bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * 0.97 > 500 ? 500 : width * 0.97,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImageBytes != null
                              ? MemoryImage(_profileImageBytes!)
                              : null,
                          child: _profileImageBytes == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Nome',
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Data de Nascimento',
                  controller: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [_birthDateMask],
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Contato',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                ),
                SizedBox(height: height * 0.02),
                CustomDropdownField(
                  label: 'Gênero',
                  items: _genderOptions,
                  value: _genderOptions.contains(_genderController.text)
                      ? _genderController.text
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value ?? '';
                    });
                  },
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  label: 'Classe/Associação',
                  controller: _associationController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.04),
                PrimaryButton(
                  label: 'Salvar Alterações',
                  onPressed: _saveChanges,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4,
        onTap: (index) {
          // Implementar navegação
        },
      ),
    );
  }
}