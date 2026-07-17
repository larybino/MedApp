import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/state/medication_provider.dart';
import 'package:frontend/core/state/user_provider.dart';
import 'package:frontend/core/state/member_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medication/screens/medication_list_screen.dart';
import 'package:frontend/features/models/medication_model.dart';
import 'package:frontend/features/models/extracted_medication_model.dart';
import 'package:frontend/features/service/medication_service.dart';
import 'package:frontend/core/utils/input_utils.dart';
import 'package:frontend/shared/widgets/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateMedicationScreen extends StatefulWidget {
  const CreateMedicationScreen({
    super.key,
    this.initialMedication,
    this.confirmAcquisitionMode = false,
  });

  final MedicationModel? initialMedication;
  final bool confirmAcquisitionMode;

  @override
  State<CreateMedicationScreen> createState() => _CreateMedicationScreenState();
}

class _MedicationFormData {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final doseAmountController = TextEditingController();
  final doseUnitController = TextEditingController();
  final activeIngredientsController = TextEditingController();
  final administrationRouteController = TextEditingController();
  final pharmaceuticalFormController = TextEditingController();
  final durationController = TextEditingController();
  final stockController = TextEditingController();

  String selectedInterval = 'EIGHT_HOURS';
  String durationType = 'DAYS';
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  Uint8List? medicationImageBytes;
  String? medicationImageBase64;
  bool acquisitionConfirmed = false;

  bool needsManualIntervalReview = false;
  bool needsManualDosageReview = false;

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    doseAmountController.dispose();
    doseUnitController.dispose();
    activeIngredientsController.dispose();
    administrationRouteController.dispose();
    pharmaceuticalFormController.dispose();
    durationController.dispose();
    stockController.dispose();
  }
}

class _CreateMedicationScreenState extends State<CreateMedicationScreen> {
  final List<_MedicationFormData> _forms = [_MedicationFormData()];
  final MedicationService _medicationService = MedicationService();
  int? _selectedTargetUserId;
  bool _isLoading = false;
  bool _isScanning = false;
  bool _showAdvanced = false;
  final _picker = ImagePicker();

  final List<Map<String, String>> _intervals = [
    {'value': 'FOUR_HOURS', 'label': 'A cada 4 horas'},
    {'value': 'SIX_HOURS', 'label': 'A cada 6 horas'},
    {'value': 'EIGHT_HOURS', 'label': 'A cada 8 horas'},
    {'value': 'TWELVE_HOURS', 'label': 'A cada 12 horas'},
    {'value': 'TWENTY_FOUR_HOURS', 'label': 'Uma vez ao dia'},
  ];

  bool get _isEdit => widget.initialMedication != null;

  @override
  void initState() {
    super.initState();
    final med = widget.initialMedication;
    if (med == null) return;

    final form = _forms.first;
    form.nameController.text = med.name;
    form.dosageController.text = med.dosage;
    form.doseAmountController.text = _formatDoseAmount(med.doseAmount);
    form.doseUnitController.text = med.doseUnit;
    form.activeIngredientsController.text = med.activeIngredients ?? '';
    form.administrationRouteController.text = med.administrationRoute ?? '';
    form.pharmaceuticalFormController.text = med.pharmaceuticalForm ?? '';
    form.durationController.text = med.treatmentDurationDays?.toString() ?? '';
    form.stockController.text = med.stockQuantity != null
        ? _formatDoseAmount(med.stockQuantity!)
        : '';
    form.selectedInterval = med.doseInterval;
    form.startDate = InputUtils.parseIsoDate(med.startDate);
    form.endDate = InputUtils.parseIsoDate(med.endDate);
    form.startTime = InputUtils.parseTime(med.startTime);
    form.medicationImageBase64 = med.medicationImage;
    form.acquisitionConfirmed = widget.confirmAcquisitionMode
        ? true
        : med.acquisitionConfirmed;

    if (med.treatmentDurationDays != null && med.treatmentDurationDays! > 0) {
      form.durationType = 'DAYS';
    } else if (med.endDate != null && med.endDate!.isNotEmpty) {
      form.durationType = 'DATE';
    } else {
      form.durationType = 'CONTINUOUS';
    }

    _selectedTargetUserId = med.userId;

    _showAdvanced =
        (form.medicationImageBase64 != null &&
            form.medicationImageBase64!.isNotEmpty) ||
        form.endDate != null ||
        form.stockController.text.isNotEmpty ||
        form.activeIngredientsController.text.isNotEmpty ||
        form.administrationRouteController.text.isNotEmpty ||
        form.pharmaceuticalFormController.text.isNotEmpty;
  }

  String _formatDoseAmount(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  Future<void> _pickImage(int index) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 70,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _forms[index].medicationImageBytes = bytes;
        _forms[index].medicationImageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _pickDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _forms[index].startDate = picked);
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _forms[index].startTime = picked);
  }

  Future<void> _pickEndDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _forms[index].startDate ?? DateTime.now(),
      firstDate: _forms[index].startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _forms[index].endDate = picked);
  }

  Future<void> _scanPrescription() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primary,
              ),
              title: const Text('Arquivo PDF'),
              onTap: () => Navigator.pop(context, 'pdf'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (choice == null) return;

    Uint8List? bytes;
    String? fileName;
    String? mimeType;

    if (choice == 'pdf') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) return;

      bytes = result.files.single.bytes;
      fileName = result.files.single.name;
      mimeType = 'application/pdf';
    } else {
      final source = choice == 'camera'
          ? ImageSource.camera
          : ImageSource.gallery;
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;

      bytes = await picked.readAsBytes();
      fileName = picked.name;
      mimeType = picked.name.toLowerCase().endsWith('.png')
          ? 'image/png'
          : 'image/jpeg';
    }

    setState(() => _isScanning = true);
    try {
      final extracted = await _medicationService.extractFromPrescription(
        bytes!,
        fileName,
        mimeType,
      );

      if (extracted.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Não foi possível identificar medicamentos na receita.',
              ),
            ),
          );
        }
        return;
      }

      _populateFormsFromExtraction(extracted);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _populateFormsFromExtraction(List<ExtractedMedicationModel> extracted) {
    for (final f in _forms) {
      f.dispose();
    }

    final newForms = extracted.map((e) {
      final form = _MedicationFormData();
      form.nameController.text = e.name ?? '';
      form.dosageController.text = e.dosage ?? '';
      form.doseAmountController.text = e.doseAmount != null
          ? _formatDoseAmount(e.doseAmount!)
          : '';
      form.doseUnitController.text = e.doseUnit ?? '';
      form.activeIngredientsController.text = e.activeIngredients ?? '';
      form.administrationRouteController.text = e.administrationRoute ?? '';
      form.pharmaceuticalFormController.text = e.pharmaceuticalForm ?? '';

      if (!e.requiresManualInterval && e.doseInterval != null) {
        form.selectedInterval = e.doseInterval!;
      }
      form.needsManualIntervalReview = e.requiresManualInterval;
      form.needsManualDosageReview = e.requiresManualDosage;

      final days = e.parsedTreatmentDurationDays;
      if (days != null) {
        form.durationType = 'DAYS';
        form.durationController.text = days.toString();
      }

      return form;
    }).toList();

    setState(() {
      _forms
        ..clear()
        ..addAll(newForms);
      _showAdvanced = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${newForms.length} medicamento(s) identificado(s). Revise os campos destacados antes de cadastrar.',
        ),
      ),
    );
  }

  Map<String, dynamic> _buildPayload(_MedicationFormData form) {
    return {
      'name': form.nameController.text.trim(),
      'dosage': form.dosageController.text.trim(),
      'doseInterval': form.selectedInterval,
      'doseAmount': double.tryParse(
        form.doseAmountController.text.replaceAll(',', '.'),
      ),
      'doseUnit': form.doseUnitController.text.trim(),
      if (form.activeIngredientsController.text.isNotEmpty)
        'activeIngredients': form.activeIngredientsController.text.trim(),
      if (form.administrationRouteController.text.isNotEmpty)
        'administrationRoute': form.administrationRouteController.text.trim(),
      if (form.pharmaceuticalFormController.text.isNotEmpty)
        'pharmaceuticalForm': form.pharmaceuticalFormController.text.trim(),
      if (form.medicationImageBase64 != null)
        'medicationImage': form.medicationImageBase64,
      if (form.startDate != null)
        'startDate': form.startDate!.toIso8601String().substring(0, 10),
      if (form.durationType == 'DAYS' &&
          form.durationController.text.isNotEmpty)
        'treatmentDurationDays': int.tryParse(form.durationController.text),
      if (form.durationType == 'DATE' && form.endDate != null)
        'endDate': form.endDate!.toIso8601String().substring(0, 10),
      if (form.startTime != null)
        'startTime':
            '${form.startTime!.hour.toString().padLeft(2, '0')}:${form.startTime!.minute.toString().padLeft(2, '0')}:00',
      if (form.stockController.text.isNotEmpty)
        'stockQuantity': double.tryParse(
          form.stockController.text.replaceAll(',', '.'),
        ),
      if (_selectedTargetUserId != null) 'userId': _selectedTargetUserId,
      'acquisitionConfirmed': form.acquisitionConfirmed,
    };
  }

  void _addMedicationForm() =>
      setState(() => _forms.add(_MedicationFormData()));

  void _removeForm(int index) {
    _forms[index].dispose();
    setState(() => _forms.removeAt(index));
  }

  Future<void> _submit() async {
    for (final form in _forms) {
      final doseAmountValid =
          double.tryParse(
            form.doseAmountController.text.replaceAll(',', '.'),
          ) !=
          null;
      final stockValid =
          form.stockController.text.isNotEmpty &&
          double.tryParse(form.stockController.text.replaceAll(',', '.')) !=
              null;
      if (form.nameController.text.isEmpty ||
          form.dosageController.text.isEmpty ||
          !doseAmountValid ||
          form.doseUnitController.text.isEmpty ||
          !stockValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Nome, dosagem, quantidade por dose, unidade e '
              'quantidade em estoque são obrigatórios em todos os itens',
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      if (_isEdit) {
        final form = _forms.first;
        await context.read<MedicationProvider>().updateMedication(
          widget.initialMedication!.id,
          _buildPayload(form),
        );
      } else {
        for (final form in _forms) {
          await context.read<MedicationProvider>().createMedication(
            _buildPayload(form),
          );
        }
      }
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context, true);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MedicationListScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    for (final f in _forms) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final userProvider = context.watch<UserProvider>();
    final memberProvider = context.watch<MemberProvider>();
    final uniqueMembers = {
      for (final m in memberProvider.members) m.id: m,
    }.values.toList();
    final selectedUserId =
        _selectedTargetUserId != null &&
            uniqueMembers.any((m) => m.id == _selectedTargetUserId)
        ? _selectedTargetUserId
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Editar Medicamento' : 'Cadastrar Medicamento'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isEdit)
              OutlinedButton.icon(
                onPressed: _isScanning ? null : _scanPrescription,
                icon: _isScanning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.document_scanner),
                label: Text(
                  _isScanning ? 'Analisando receita...' : 'Escanear receita',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  disabledForegroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            SizedBox(height: height * 0.03),

            const _RequiredFieldsNote(),
            SizedBox(height: height * 0.02),

            if (userProvider.isMaster && memberProvider.members.isNotEmpty) ...[
              SectionTitle(title: 'Para quem é este medicamento?'),
              const SizedBox(height: 8),
              DropdownField(
                value: selectedUserId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Para mim')),
                  ...uniqueMembers.map(
                    (m) => DropdownMenuItem(value: m.id, child: Text(m.name)),
                  ),
                ],
                onChanged: (v) =>
                    setState(() => _selectedTargetUserId = v as int?),
              ),
              SizedBox(height: height * 0.03),
            ],

            for (int i = 0; i < _forms.length; i++) ...[
              if (_forms.length > 1) ...[
                Row(
                  children: [
                    SectionTitle(title: 'Medicamento ${i + 1}'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.danger),
                      onPressed: () => _removeForm(i),
                    ),
                  ],
                ),
              ],

              SectionTitle(title: 'Dados principais'),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Nome do medicamento *',
                controller: _forms[i].nameController,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: height * 0.015),
              CustomTextField(
                label: 'Dosagem * (concentração, ex: 500mg)',
                controller: _forms[i].dosageController,
                keyboardType: TextInputType.text,
              ),
              if (_forms[i].needsManualDosageReview) ...[
                const SizedBox(height: 4),
                const _ReviewHint(
                  text:
                      'Não identificado na receita — confirme ou preencha manualmente.',
                ),
              ],
              SizedBox(height: height * 0.015),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Quantidade por dose *',
                      controller: _forms[i].doseAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Unidade * (cp, ml, gota, jato...)',
                      controller: _forms[i].doseUnitController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.015),

              SectionTitle(title: 'Frequência *'),
              const SizedBox(height: 8),
              DropdownField(
                value: _forms[i].selectedInterval,
                items: _intervals
                    .map(
                      (item) => DropdownMenuItem(
                        value: item['value'],
                        child: Text(item['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _forms[i].selectedInterval = v as String;
                  _forms[i].needsManualIntervalReview = false;
                }),
              ),
              if (_forms[i].needsManualIntervalReview) ...[
                const SizedBox(height: 4),
                const _ReviewHint(
                  text:
                      'Intervalo não reconhecido automaticamente (RN001) — confirme o valor correto.',
                ),
              ],
              SizedBox(height: height * 0.02),

              SectionTitle(title: 'Agendamento'),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.confirmAcquisitionMode
                        ? null
                        : () => setState(
                            () => _forms[i].acquisitionConfirmed =
                                !_forms[i].acquisitionConfirmed,
                          ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _forms[i].acquisitionConfirmed
                            ? AppColors.primary
                            : AppColors.secondary.withValues(alpha: 0.2),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _forms[i].acquisitionConfirmed
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                  const SizedBox(width: 12),
                  const Text(
                    'Já tenho este medicamento',
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),

              if (_forms[i].acquisitionConfirmed) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeButton(
                        icon: Icons.calendar_today,
                        label: _forms[i].startDate != null
                            ? '${_forms[i].startDate!.day.toString().padLeft(2, '0')}/${_forms[i].startDate!.month.toString().padLeft(2, '0')}/${_forms[i].startDate!.year}'
                            : 'Data início',
                        onTap: () => _pickDate(i),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DateTimeButton(
                        icon: Icons.access_time,
                        label: _forms[i].startTime != null
                            ? '${_forms[i].startTime!.hour.toString().padLeft(2, '0')}:${_forms[i].startTime!.minute.toString().padLeft(2, '0')}'
                            : 'Horário',
                        onTap: () => _pickTime(i),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
              ],

              SectionTitle(title: 'Término do tratamento'),
              const SizedBox(height: 8),
              DropdownField(
                value: _forms[i].durationType,
                items: const [
                  DropdownMenuItem(
                    value: 'DAYS',
                    child: Text('Por quantidade de dias'),
                  ),
                  DropdownMenuItem(
                    value: 'DATE',
                    child: Text('Até uma data específica'),
                  ),
                  DropdownMenuItem(
                    value: 'CONTINUOUS',
                    child: Text('Uso contínuo (Sem data final)'),
                  ),
                ],
                onChanged: (v) =>
                    setState(() => _forms[i].durationType = v as String),
              ),
              if (_forms[i].durationType == 'DAYS') ...[
                SizedBox(height: height * 0.015),
                CustomTextField(
                  label: 'Duração do tratamento (dias)',
                  controller: _forms[i].durationController,
                  keyboardType: TextInputType.number,
                ),
              ],
              if (_forms[i].durationType == 'DATE') ...[
                SizedBox(height: height * 0.015),
                DateTimeButton(
                  icon: Icons.event,
                  label: _forms[i].endDate != null
                      ? 'Fim: ${_forms[i].endDate!.day.toString().padLeft(2, '0')}/${_forms[i].endDate!.month.toString().padLeft(2, '0')}/${_forms[i].endDate!.year}'
                      : 'Selecionar data final',
                  onTap: () => _pickEndDate(i),
                ),
              ],
              SizedBox(height: height * 0.02),

              SectionTitle(title: 'Estoque'),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Quantidade inicial * (mesma unidade da dose)',
                controller: _forms[i].stockController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ex: se a dose é em gotas, informe o total de gotas do '
                'frasco; se for em ml ou g, informe o total em ml ou g.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: height * 0.02),

              if (_showAdvanced) ...[
                SectionTitle(title: 'Opções avançadas'),
                const SizedBox(height: 8),
                ImagePickerCard(
                  imageBytes: _forms[i].medicationImageBytes,
                  imageBase64: _forms[i].medicationImageBase64,
                  onTap: () => _pickImage(i),
                ),
                SizedBox(height: height * 0.02),
                SectionTitle(title: 'Informações adicionais'),
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'Princípio ativo',
                  controller: _forms[i].activeIngredientsController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.015),
                CustomTextField(
                  label: 'Via de administração',
                  controller: _forms[i].administrationRouteController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.015),
                CustomTextField(
                  label: 'Forma farmacêutica',
                  controller: _forms[i].pharmaceuticalFormController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: height * 0.015),
              ],

              if (i < _forms.length - 1) ...[
                SizedBox(height: height * 0.02),
                const Divider(),
                SizedBox(height: height * 0.02),
              ],
            ],

            OutlinedButton.icon(
              onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
              icon: Icon(_showAdvanced ? Icons.expand_less : Icons.tune),
              label: Text(
                _showAdvanced ? 'Ocultar opções avançadas' : 'Opções avançadas',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            if (!_isEdit) ...[
              SizedBox(height: height * 0.03),
              OutlinedButton.icon(
                onPressed: _addMedicationForm,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar mais remédios'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
            ],
            AppButton(
              label: _isEdit ? 'Salvar' : 'Cadastrar',
              onPressed: _submit,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ReviewHint extends StatelessWidget {
  const _ReviewHint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ),
      ],
    );
  }
}

class _RequiredFieldsNote extends StatelessWidget {
  const _RequiredFieldsNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      '* Campos obrigatórios',
      style: TextStyle(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: AppColors.secondary.withValues(alpha: 0.6),
      ),
    );
  }
}
