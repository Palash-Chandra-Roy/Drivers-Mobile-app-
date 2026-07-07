import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/core/widgets/custom_text_field.dart';
import 'package:yjeek_driver/features/incidents_safety/provider/incident_provider.dart';

class WrongMissingItemsScreen extends StatefulWidget {
  const WrongMissingItemsScreen({super.key});

  @override
  State<WrongMissingItemsScreen> createState() => _WrongMissingItemsScreenState();
}

class _WrongMissingItemsScreenState extends State<WrongMissingItemsScreen> {
  final _notesController = TextEditingController();
  final _selectedIssues = <String>{};

  static const _options = ['Missing item', 'Wrong item', 'Damaged item'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedIssues.isEmpty) {
      AppHelpers.showSnackBar(context, 'Please select at least one issue', isError: true);
      return;
    }
    final success = await context.read<IncidentProvider>().submitItemIssue(
          _selectedIssues.toList(),
          _notesController.text.trim(),
        );
    if (!mounted) return;
    if (success) {
      AppHelpers.showSnackBar(context, 'Report submitted');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Wrong / Missing Items'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select issue type:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSizes.paddingSm),
              ..._options.map((option) => Card(
                    child: CheckboxListTile(
                      value: _selectedIssues.contains(option),
                      activeColor: AppColors.primary,
                      title: Text(option),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedIssues.add(option);
                          } else {
                            _selectedIssues.remove(option);
                          }
                        });
                      },
                    ),
                  )),
              const SizedBox(height: AppSizes.paddingMd),
              CustomTextField(
                controller: _notesController,
                labelText: 'Additional Notes',
                hintText: 'Describe the issue...',
              ),
              const Spacer(),
              CustomButton(
                title: AppStrings.submit,
                isLoading: provider.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
