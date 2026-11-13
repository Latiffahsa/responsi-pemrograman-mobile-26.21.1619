import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiService {
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/users');
    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'x-api-key': AppConfig.apiKey,
            },
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('GET /users -> ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      }
      throw ApiException('Server mengembalikan error (${response.statusCode})');
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw ApiException('Permintaan terlalu lama (timeout).');
    } on http.ClientException {
      throw ApiException('Gagal menghubungi server.');
    } on FormatException {
      throw ApiException('Format data dari server tidak valid.');
    }
  }
}
