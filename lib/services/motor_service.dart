import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MotorService {
  static const String _baseUrl =
      'https://telecharger-defines-widespread-muslim.trycloudflare.com';

  // ================= REGISTER MOTOR =================
  static Future<Map<String, dynamic>> registerMotor({
    required String userId,
    required String ownerName,
    required String email,
    required String brand,
    required String model,
    required String color,
    required int widthCm,
  }) async {
    final body = {
      "user_id": userId,
      "owner_name": ownerName,
      "phone": "",
      "email": email,
      "brand": brand,
      "model": _mapModelToBackend(model),
      "color": color,
      "length_cm": _lengthByModel(model),
      "width_cm": widthCm,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/api/motorcycles/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _parseMap(response);
  }

  // ================= UPDATE MOTOR =================
  static Future<Map<String, dynamic>> updateMyMotor({
    required String code,
    required String brand,
    required String model,
    required String color,
    required int widthCm,
  }) async {
    final body = {
      "brand": brand,
      "model": _mapModelToBackend(model),
      "color": color,
      "length_cm": _lengthByModel(model),
      "width_cm": widthCm,
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/api/motorcycles/my/$code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _parseMap(response);
  }

  // ================= GET MOTOR BY USER =================
  static Future<List<Map<String, dynamic>>> getMotorByUser(
    String userId,
  ) async {
    final uri = Uri.parse('$_baseUrl/api/motorcycles/user/$userId');

    final response = await http.get(uri);

    // DEBUG PENTING
    debugPrint('RAW BODY => ${response.body}');

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Expected List, got ${decoded.runtimeType}');
    }

    return decoded.map<Map<String, dynamic>>((e) {
      return {
        "id": e["id"]?.toString(),
        "code": e["code"]?.toString(),
        "user_id": e["user_id"]?.toString(),
        "owner_name": e["owner_name"]?.toString(),
        "brand": e["brand"]?.toString(),
        "model": e["model"]?.toString(),
        "color": e["color"]?.toString() ?? "",
        "length_cm": (e["length_cm"] as num?)?.toInt() ?? 0,
        "width_cm": (e["width_cm"] as num?)?.toInt() ?? 0,
        "created_at": e["created_at"]?.toString(),
        "updated_at": e["updated_at"]?.toString(),
      };
    }).toList();
  }

  // ================= INTERNAL HELPERS =================
  static Map<String, dynamic> _parseMap(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Invalid response format');
    }

    throw Exception(
      decoded is Map
          ? decoded['detail'] ?? decoded['message'] ?? decoded.toString()
          : decoded.toString(),
    );
  }

  static String _mapModelToBackend(String model) {
    switch (model) {
      case 'bebek':
        return 'bebek';
      case 'listrik':
        return 'listrik';
      case 'sepeda':
        return 'sepeda';
      case 'moge':
        return 'moge';
      case 'adventure':
        return 'adventure';
      case 'sport':
        return 'sport';
      case 'matic':
        return 'matic';
      default:
        return model;
    }
  }

  static int _lengthByModel(String model) {
    switch (model) {
      case 'sport':
        return 200;
      case 'bebek':
        return 185;
      case 'moge':
        return 215;
      case 'adventure':
        return 210;
      case 'listrik':
        return 175;
      case 'sepeda':
        return 170;
      default:
        return 180; // matic
    }
  }

  // ===========================================================
  // DELETE MOTOR
  // ===========================================================
  static Future<void> deleteMotor(String code) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/motorcycles/my/$code'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final decoded = jsonDecode(response.body);
      throw Exception(
        decoded['detail'] ?? decoded['message'] ?? 'Gagal menghapus motor',
      );
    }
  }
}
