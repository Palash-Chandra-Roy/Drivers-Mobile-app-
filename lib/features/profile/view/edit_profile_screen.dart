import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/utils/validators.dart';
import 'package:yjeek_driver/core/widgets/app_loader.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/core/widgets/custom_text_field.dart';
import 'package:yjeek_driver/features/profile/model/profile_model.dart';
import 'package:yjeek_driver/features/profile/provider/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    if (profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProfileProvider>().loadProfile().then((_) {
          if (!mounted) return;
          final p = context.read<ProfileProvider>().profile;
          if (p != null) {
            _nameController.text = p.name;
            _phoneController.text = p.phone;
            _emailController.text = p.email ?? '';
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final current = context.read<ProfileProvider>().profile;
    if (current == null) return;

    final updated = ProfileModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      vehicleType: current.vehicleType,
      plateNumber: current.plateNumber,
      licenseNumber: current.licenseNumber,
      licenseStatus: current.licenseStatus,
      rating: current.rating,
    );

    final success = await context.read<ProfileProvider>().updateProfile(updated);
    if (!mounted) return;
    if (success) {
      AppHelpers.showSnackBar(context, 'Profile updated');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Profile'),
      body: provider.isLoading && provider.profile == null
          ? const AppLoader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (v) => Validators.required(v, fieldName: 'Name'),
                      ),
                      const SizedBox(height: AppSizes.paddingMd),
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Phone',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: AppSizes.paddingMd),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const Spacer(),
                      CustomButton(
                        title: AppStrings.save,
                        isLoading: provider.isLoading,
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
