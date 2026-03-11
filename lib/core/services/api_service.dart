import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/post_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final payload = {
      'username': username,
      'password': password,
      'expiresInMins': 30,
    };

    final json = await _sendRequest(
      () => _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ),
    );

    return UserModel.fromJson(json);
  }

  Future<List<ProductModel>> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    final json = await _sendRequest(() => _client.get(uri));

    final items = json['products'];
    if (items is! List) return [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }

  Future<List<PostModel>> fetchPosts({
    required int limit,
    required int skip,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts?limit=$limit&skip=$skip');
    final json = await _sendRequest(() => _client.get(uri));

    final items = json['posts'];
    if (items is! List) return [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> _sendRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = _extractMessage(response.body) ??
            'Request failed with status ${response.statusCode}';
        throw ApiException(message);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Unexpected server response.');
      }

      return decoded;
    } on SocketException {
      throw const ApiException('No internet connection. Please try again.');
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on HttpException {
      throw const ApiException('Could not reach server. Please try again.');
    } on FormatException {
      throw const ApiException('Invalid response from server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }

  String? _extractMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic> && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
