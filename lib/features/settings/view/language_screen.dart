import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/constants/app_strings.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/settings/provider/settings_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = ['English', 'Arabic', 'Bangla'];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Language'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            children: [
              ..._languages.map((lang) => Card(
                    margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                    child: ListTile(
                      title: Text(lang),
                      trailing: settings.language == lang
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () => settings.setLanguage(lang),
                    ),
                  )),
              const Spacer(),
              CustomButton(
                title: AppStrings.save,
                onPressed: () {
                  AppHelpers.showSnackBar(context, 'Language set to ${settings.language}');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
