import 'dart:convert';
import 'package:http/http.dart' as http;

class NiubizService {
  final String backendUrl;

  NiubizService(this.backendUrl);

  /// Obtiene el token de acceso desde el backend
  Future<String> fetchAccessToken() async {
    final response = await http.post(
      Uri.parse('$backendUrl/api/security/v1/security'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': 'integraciones@niubiz.com.pe',
        'password': '_7z3@8fF',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['accessToken'];
    } else {
      throw Exception('Error al obtener el token de acceso: ${response.body}');
    }
  }

  /// Genera un token de sesión utilizando el token de acceso
  Future<String> fetchSessionToken(String accessToken, double amount) async {
    final response = await http.post(
      Uri.parse(
          '$backendUrl/api.ecommerce/v2/ecommerce/token/session/456879852'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'channel': 'web',
        'amount': amount,
        'antifraud': {
          'clientIp': '24.252.107.29',
          'merchantDefineData': {
            'MDD15': 'Valor MDD 15',
            'MDD20': 'Valor MDD 20',
          },
        },
        'dataMap': {
          'cardholderCity': 'Lima',
          'cardholderCountry': 'PE',
          'cardholderAddress': 'Av Jose Pardo 831',
          'cardholderPostalCode': '12345',
          'cardholderState': 'LIM',
          'cardholderPhoneNumber': '987654321',
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sessionKey'];
    } else {
      throw Exception('Error al generar el token de sesión: ${response.body}');
    }
  }
}
