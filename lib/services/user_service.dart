import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl =
      'https://telecharger-defines-widespread-muslim.trycloudflare.com';

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    return _handle(response);
  }

  // ================= GET USER (LOGIN BY ID) =================
  static Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/users/$userId'));

    return _handle(response);
  }

  // ================= HELPER =================
  static Map<String, dynamic> _handle(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw Exception(
        decoded['detail'] ?? decoded['message'] ?? decoded.toString(),
      );
    }
  }
}
