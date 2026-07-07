class ApiService {
  Future<Map<String, dynamic>> get(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'data': null, 'endpoint': endpoint};
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'data': body, 'endpoint': endpoint};
  }
}
