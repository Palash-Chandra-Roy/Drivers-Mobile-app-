import 'package:flutter/material.dart';

class AppHelpers {
  AppHelpers._();

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String formatDistance(double km) {
    return '${km.toStringAsFixed(1)} km';
  }

  static Future<void> delayNavigation(
      BuildContext context, String routeName) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}
