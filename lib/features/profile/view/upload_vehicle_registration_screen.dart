import 'package:flutter/material.dart';
import 'package:yjeek_driver/core/constants/app_assets.dart';
import 'package:yjeek_driver/features/profile/view/doc_upload_ui.dart';

/// DU3 · Upload — Vehicle registration
class UploadVehicleRegistrationScreen extends StatefulWidget {
  const UploadVehicleRegistrationScreen({super.key});

  @override
  State<UploadVehicleRegistrationScreen> createState() =>
      _UploadVehicleRegistrationScreenState();
}

class _UploadVehicleRegistrationScreenState
    extends State<UploadVehicleRegistrationScreen> {
  bool _frontUploaded = true;
  bool _backUploaded = true;
  bool _frontViewUploaded = false;
  bool _sideViewUploaded = false;
  bool _plateBackUploaded = false;
  bool _insuranceUploaded = false;
  int _vehicleType = 0; // 0 Car, 1 Motorcycle

  final _makeController = TextEditingController(text: 'Toyota');
  final _modelController = TextEditingController(text: 'Hilux');
  final _colorController = TextEditingController(text: 'White');
  final _plateController = TextEditingController(text: '1234');

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pick(void Function() markUploaded) async {
    final bytes = await pickDocPhoto(context);
    if (bytes != null) setState(markUploaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DocColors.screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocHeader(title: 'Vehicle registration'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card, details, photos and insurance.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DocColors.textMuted,
                        height: 16 / 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const DocSectionHeader(text: 'Registration card'),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Front side',
                      uploaded: _frontUploaded,
                      onTap: () => _pick(() => _frontUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Back side',
                      uploaded: _backUploaded,
                      onTap: () => _pick(() => _backUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    const DocSectionHeader(text: 'Vehicle details'),
                    const SizedBox(height: 12),
                    _buildVehicleTypeSelector(),
                    const SizedBox(height: 12),
                    DocTextField(
                      label: 'Make',
                      hint: 'Toyota',
                      controller: _makeController,
                    ),
                    const SizedBox(height: 12),
                    DocTextField(
                      label: 'Model',
                      hint: 'Hilux',
                      controller: _modelController,
                    ),
                    const SizedBox(height: 12),
                    DocTextField(
                      label: 'Color',
                      hint: 'White',
                      controller: _colorController,
                    ),
                    const SizedBox(height: 12),
                    DocTextField(
                      label: 'Vehicle / plate number',
                      hint: '1234',
                      controller: _plateController,
                    ),
                    const SizedBox(height: 12),
                    const DocSectionHeader(text: 'Vehicle photos'),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Front view',
                      helper: 'Show the whole vehicle',
                      uploaded: _frontViewUploaded,
                      onTap: () => _pick(() => _frontViewUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Side view',
                      uploaded: _sideViewUploaded,
                      onTap: () => _pick(() => _sideViewUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Plate / back',
                      helper: 'Optional',
                      uploaded: _plateBackUploaded,
                      onTap: () => _pick(() => _plateBackUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    const DocSectionHeader(text: 'Insurance'),
                    const SizedBox(height: 12),
                    DocUploadBox(
                      title: 'Insurance document',
                      uploaded: _insuranceUploaded,
                      onTap: () => _pick(() => _insuranceUploaded = true),
                    ),
                    const SizedBox(height: 12),
                    const DocTextField(
                      label: 'Insurance expiry date',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 22),
                    DocPrimaryButton(
                      label: 'Save',
                      onPressed: () {
                        showDocSnack(context, 'Vehicle registration saved');
                        Navigator.maybePop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VEHICLE TYPE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: DocColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _typeOption(0, AppAssets.vehicleCar, 'Car'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _typeOption(1, AppAssets.vehicleBike, 'Motorcycle'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeOption(int index, String iconAsset, String label) {
    final selected = _vehicleType == index;
    return GestureDetector(
      onTap: () => setState(() => _vehicleType = index),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? DocColors.green : DocColors.white,
          borderRadius: BorderRadius.circular(10),
          border: selected ? null : Border.all(color: DocColors.fieldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAsset, width: 18, height: 18, fit: BoxFit.contain),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : DocColors.textField,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
