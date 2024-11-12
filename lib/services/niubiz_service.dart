import 'dart:convert';
import 'package:http/http.dart' as http;

class NiubizService {
  static const String _username = "integraciones@niubiz.com.pe";
  static const String _password = "_7z3@8fF";
  static const String _sandboxUrl =
      "https://apisandbox.vnforappstest.com/api.security/v1/security";

  static Future<String?> getAccessToken() async {
    try {
      final credentials = '$_username:$_password';
      final encodedCredentials = base64Encode(utf8.encode(credentials));
      final headers = {
        'Authorization': 'Basic $encodedCredentials',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(_sandboxUrl),
        headers: headers,
      );

      if (response.statusCode == 201) {
        final accessToken = response.body.trim();
        return accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
