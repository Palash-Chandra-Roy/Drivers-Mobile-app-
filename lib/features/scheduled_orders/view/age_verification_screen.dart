import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/core/constants/app_colors.dart';
import 'package:yjeek_driver/core/constants/app_sizes.dart';
import 'package:yjeek_driver/core/utils/app_helpers.dart';
import 'package:yjeek_driver/core/widgets/custom_app_bar.dart';
import 'package:yjeek_driver/core/widgets/custom_button.dart';
import 'package:yjeek_driver/features/scheduled_orders/provider/scheduled_order_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class AgeVerificationScreen extends StatefulWidget {
  const AgeVerificationScreen({super.key});

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  final _checks = <String, bool>{
    'Customer is 18+': false,
    'ID matches name': false,
    'ID is not expired': false,
  };

  bool get _allChecked => _checks.values.every((v) => v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Age Verification'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Customer ID',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              const Text(
                'Please check the customer\'s government-issued ID before handing over restricted items.',
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: AppSizes.paddingLg),
              ..._checks.keys.map((key) => Card(
                    child: CheckboxListTile(
                      value: _checks[key],
                      activeColor: AppColors.primary,
                      title: Text(key),
                      onChanged: (val) => setState(() => _checks[key] = val ?? false),
                    ),
                  )),
              const Spacer(),
              CustomButton(
                title: 'Confirm Verification',
                onPressed: _allChecked
                    ? () {
                        context.read<ScheduledOrderProvider>().confirmAgeVerification();
                        AppHelpers.showSnackBar(context, 'Age verified successfully');
                        Navigator.pushNamed(context, RouteNames.scheduledOrderDetails);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
