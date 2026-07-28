import 'package:yjeek_driver/core/constants/api_endpoints.dart';
import 'package:yjeek_driver/features/dashboard/model/home_model.dart';
import 'package:yjeek_driver/services/api_service.dart';

class DashboardService {
  DashboardService({ApiService? apiService})
      : _api = apiService ?? ApiService.instance;

  final ApiService _api;

  Future<DriverHomeModel> getHome() async {
    final response = await _api.get(ApiEndpoints.home);
    return _parseHomeResponse(
      response,
      failureMessage: 'Failed to load home',
    );
  }

  Future<DriverHomeModel> goOffline() async {
    final response = await _api.post(ApiEndpoints.goOffline);
    return _parseHomeResponse(
      response,
      failureMessage: 'Failed to go offline',
    );
  }

  DriverHomeModel _parseHomeResponse(
    Map<String, dynamic> response, {
    required String failureMessage,
  }) {
    if (response['success'] != true) {
      final message = response['message']?.toString();
      throw ApiException(
        (message != null && message.trim().isNotEmpty)
            ? message.trim()
            : failureMessage,
      );
    }

    try {
      return DriverHomeModel.fromJson(response);
    } on FormatException {
      throw ApiException('Invalid response from server');
    }
  }
}
