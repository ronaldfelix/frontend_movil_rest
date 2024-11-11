import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/database_helper.dart';
import '../config/config.dart';

class LoginService {
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final url = Uri.parse('${Config.baseUrl}/api/clientes/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "clave": password,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(utf8.decode(response.bodyBytes));

        // Guarda los datos del usuario en SQLite
        await DatabaseHelper().saveUser({
          'nombre': decodedBody['nombre'],
          'email': decodedBody['email'],
          'telefono': decodedBody['telefono'],
        });

        return decodedBody;
      } else {
        return null;
      }
    } catch (e) {
      print("Error durante el login: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getLoggedInUser() async {
    return await DatabaseHelper().getUser();
  }

  static Future<void> logout() async {
    await DatabaseHelper().deleteUser();
  }
}
