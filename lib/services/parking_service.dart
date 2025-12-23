// lib/services/parking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingService {
  static const String baseUrl =
      'https://telecharger-defines-widespread-muslim.trycloudflare.com';

  static const Duration timeout = Duration(seconds: 15);

  /// =============================
  /// SESSION
  /// =============================
  static Future<String> getLatestSessionId() async {
    final url = Uri.parse('$baseUrl/api/results/latest');

    final response = await http.get(url).timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch latest session (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);

    /// CASE 1: list session
    if (data is Map && data['results'] is List) {
      final List results = data['results'];

      if (results.isEmpty) {
        throw Exception('No session available');
      }

      final completed = results.firstWhere(
        (s) => s['status'] == 'completed',
        orElse: () => results.first,
      );

      return completed['session_id'];
    }

    /// CASE 2: single session object
    if (data is Map && data['session_id'] != null) {
      return data['session_id'];
    }

    throw Exception('Invalid session response format');
  }

  /// =============================
  /// RESULT
  /// =============================
  static Future<Map<String, dynamic>> getResult(String sessionId) async {
    final url = Uri.parse('$baseUrl/api/results/$sessionId');

    final response = await http.get(url).timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch result (${response.statusCode})');
    }

    return jsonDecode(response.body);
  }

  /// =============================
  /// IMAGE
  /// =============================
  static String getResultImageUrl(String sessionId) {
    return '$baseUrl/api/results/$sessionId/image';
  }
}
