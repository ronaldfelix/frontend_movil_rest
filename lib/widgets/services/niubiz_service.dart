import 'dart:convert';
import 'package:http/http.dart' as http;

class NiubizService {
  static const String _username = "integraciones@niubiz.com.pe";
  static const String _password = "_7z3@8fF";
  static const String _sandboxUrl =
      "https://apisandbox.vnforappstest.com/api.security/v1/security";
  static const String _merchantId = "456879852";
  static const String _sessionUrl =
      "https://apisandbox.vnforappstest.com/api.ecommerce/v2/ecommerce/token/session/$_merchantId";

  // Obtener token de acceso
  static Future<String?> getAccessToken() async {
    try {
      const credentials = '$_username:$_password';
      final encodedCredentials = base64Encode(utf8.encode(credentials));
      final headers = {'Authorization': 'Basic $encodedCredentials'};

      final response =
          await http.post(Uri.parse(_sandboxUrl), headers: headers);

      if (response.statusCode == 201) {
        return response.body.trim();
      } else {
        print("Error al obtener token de acceso: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción al obtener token de acceso: $e");
      return null;
    }
  }

  // Crear token de sesión
  static Future<String?> createSessionToken(
      String accessToken, double amount) async {
    try {
      final headers = {
        'Authorization': accessToken,
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "channel": "web",
        "amount": amount,
        "antifraud": {
          "clientIp": "24.252.107.29",
          "merchantDefineData": {
            "MDD4": "integraciones@niubiz.com.pe",
            "MDD32": "JD1892639123",
            "MDD75": "Registrado",
            "MDD77": 458
          }
        }
      });

      final response =
          await http.post(Uri.parse(_sessionUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['sessionKey'];
      } else {
        print("Error al crear token de sesión: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción al crear token de sesión: $e");
      return null;
    }
  }
}
