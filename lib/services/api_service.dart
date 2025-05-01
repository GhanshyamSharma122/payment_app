// File: api_services.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'https://backendpayment.onrender.com';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// 1.1 Register User
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: _headers(null),
      body: jsonEncode(userData),
    );
    return _processResponse(response);
  }

  /// 1.2 Login User
  Future<Map<String, dynamic>> loginUser(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers(null),
      body: jsonEncode({'identifier': identifier, 'password': password}),
    );

    final result = _processResponse(response);
    if (response.statusCode == 200) {
      _storage.write(key: 'auth_token', value: result['token']);
    }
    return result;
  }

  /// 2.1 Get Wallet Balance
  Future<Map<String, dynamic>> getWalletBalance() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/wallet'),
      headers: _headers(token),
    );
    return _processResponse(response);
  }

  /// 3.1 Initiate Payment
  Future<Map<String, dynamic>> initiatePayment(Map<String, dynamic> paymentData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/payment/initiate'),
      headers: _headers(token),
      body: jsonEncode(paymentData),
    );
    return _processResponse(response);
  }

  /// 4.1 Sync Offline Transactions
  Future<Map<String, dynamic>> syncOfflineTransactions(Map<String, dynamic> syncData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/offline/sync'),
      headers: _headers(token),
      body: jsonEncode(syncData),
    );
    return _processResponse(response);
  }

  /// 5.1 Get Transaction History
  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/transactions'),
      headers: _headers(token),
    );
    final decoded = _processResponse(response);
    return decoded is List ? decoded : [];
  }

  /// Handles all HTTP responses
  dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['error'] ?? 'Unexpected error');
    }
  }
}
