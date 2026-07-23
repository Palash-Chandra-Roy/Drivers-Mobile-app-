import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yjeek_driver/core/constants/api_endpoints.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => message;
}

/// Central HTTP client for all app APIs.
class ApiService {
  ApiService._({HttpClient? client})
      : _client = client ?? HttpClient(),
        baseUrl = ApiEndpoints.baseUrl;

  static final ApiService instance = ApiService._();

  factory ApiService() => instance;

  static const Duration _timeout = Duration(seconds: 30);

  final HttpClient _client;
  final String baseUrl;
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String? token) {
    _accessToken = (token != null && token.isNotEmpty) ? token : null;
  }

  void clearAccessToken() => _accessToken = null;

  Future<Map<String, dynamic>> get(String endpoint) {
    return _request('GET', endpoint);
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return _request('POST', endpoint, body: body);
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return _request('PATCH', endpoint, body: body);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final request = await _openRequest(method, uri).timeout(_timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final token = _accessToken;
      if (token != null && token.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      if (body != null) {
        request.add(utf8.encode(jsonEncode(body)));
      }

      final response = await request.close().timeout(_timeout);
      final raw = await response.transform(utf8.decoder).join();

      Map<String, dynamic>? decoded;
      if (raw.isNotEmpty) {
        final dynamic parsed = jsonDecode(raw);
        if (parsed is Map<String, dynamic>) {
          decoded = parsed;
        } else if (parsed is Map) {
          decoded = Map<String, dynamic>.from(parsed);
        } else {
          throw ApiException('Invalid response from server');
        }
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _extractErrorMessage(decoded) ??
              'Request failed (${response.statusCode})',
          statusCode: response.statusCode,
          code: _extractErrorCode(decoded),
        );
      }

      if (decoded == null) {
        throw ApiException('Invalid response from server');
      }

      return decoded;
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on HandshakeException {
      throw ApiException('Unable to establish a secure connection.');
    } on HttpException {
      throw ApiException('Unable to reach the server. Please try again.');
    } on FormatException {
      throw ApiException('Invalid response from server');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<HttpClientRequest> _openRequest(String method, Uri uri) {
    switch (method) {
      case 'GET':
        return _client.getUrl(uri);
      case 'POST':
        return _client.postUrl(uri);
      case 'PATCH':
        return _client.patchUrl(uri);
      case 'PUT':
        return _client.putUrl(uri);
      case 'DELETE':
        return _client.deleteUrl(uri);
      default:
        throw ApiException('Unsupported HTTP method: $method');
    }
  }

  String? _extractErrorMessage(Map<String, dynamic>? json) {
    if (json == null) return null;

    final message = json['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final error = json['error'];
    if (error is String && error.trim().isNotEmpty) return error.trim();
    if (error is Map) {
      final nested = error['message'];
      if (nested is String && nested.trim().isNotEmpty) return nested.trim();
    }

    final data = json['data'];
    if (data is Map) {
      final nested = data['message'];
      if (nested is String && nested.trim().isNotEmpty) return nested.trim();
    }

    return null;
  }

  String? _extractErrorCode(Map<String, dynamic>? json) {
    if (json == null) return null;

    final code = json['code'] ?? json['errorCode'];
    if (code != null && code.toString().trim().isNotEmpty) {
      return code.toString().trim();
    }

    final error = json['error'];
    if (error is Map) {
      final nested = error['code'] ?? error['errorCode'];
      if (nested != null && nested.toString().trim().isNotEmpty) {
        return nested.toString().trim();
      }
    }

    return null;
  }
}
