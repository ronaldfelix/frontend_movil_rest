import 'dart:convert';
import 'package:http/http.dart' as http;

class NiubizService {
  static const String _username = "integraciones@niubiz.com.pe";
  static const String _password = "_7z3@8fF";
  static const String _sandboxUrl =
      "https://apisandbox.vnforappstest.com/api.security/v1/security";
  static const String _merchantId = "456879852"; // Código de Comercio
  static const String _sessionUrl =
      "https://apisandbox.vnforappstest.com/api.ecommerce/v2/ecommerce/token/session/$_merchantId";
  static const String _authorizationUrl =
      "https://apisandbox.vnforappstest.com/api.authorization/v3/authorization/ecommerce/$_merchantId";

  // Obtener token de acceso
  static Future<String?> getAccessToken() async {
    try {
      const credentials = '$_username:$_password';
      final encodedCredentials = base64Encode(utf8.encode(credentials));
      final headers = {
        'Authorization': 'Basic $encodedCredentials',
        'Content-Type': 'application/json',
      };

      print("Solicitando token de acceso...");
      final response =
          await http.post(Uri.parse(_sandboxUrl), headers: headers);

      if (response.statusCode == 201) {
        final accessToken = response.body.trim();
        print("Token de acceso recibido: $accessToken");
        return accessToken;
      } else {
        print("Error al obtener el token de acceso: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción al obtener el token de acceso: $e");
      return null;
    }
  }

  // Crear token de sesión
  static Future<Map<String, dynamic>?> createSessionToken(
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
        },
        "dataMap": {
          "cardholderCity": "Lima",
          "cardholderCountry": "PE",
          "cardholderAddress": "Av Jose Pardo 831",
          "cardholderPostalCode": "12345",
          "cardholderState": "LIM",
          "cardholderPhoneNumber": "987654321"
        }
      });

      print("Creando token de sesión...");
      final response =
          await http.post(Uri.parse(_sessionUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Token de sesión recibido: ${jsonResponse['sessionKey']}");
        return jsonResponse;
      } else {
        print("Error al crear el token de sesión: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción al crear el token de sesión: $e");
      return null;
    }
  }

  // Autorizar transacción
  static Future<Map<String, dynamic>?> authorizeTransaction(String accessToken,
      String sessionKey, String purchaseNumber, double amount) async {
    try {
      final headers = {
        'Authorization': accessToken,
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "channel": "web",
        "captureType": "manual",
        "countable": true,
        "order": {
          "tokenId": sessionKey,
          "purchaseNumber": purchaseNumber,
          "amount": amount,
          "currency": "PEN"
        }
      });

      print("Enviando solicitud de autorización...");
      final response = await http.post(Uri.parse(_authorizationUrl),
          headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Respuesta de autorización recibida: $jsonResponse");
        return jsonResponse;
      } else {
        print("Error en la autorización: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción durante la autorización: $e");
      return null;
    }
  }

  // Validar respuesta
  static void validatePaymentResponse(
      Map<String, dynamic> jsonResponse, double requestedAmount) {
    try {
      print("\n--- Validación de Campos Clave en la Respuesta ---");

      // STATUS
      if (jsonResponse.containsKey('STATUS')) {
        print("STATUS recibido: ${jsonResponse['STATUS']}");
        if (jsonResponse['STATUS'] == 'Authorized') {
          print("STATUS es válido: Transacción autorizada.");
        } else {
          print("STATUS inválido: Transacción no autorizada.");
        }
      } else {
        print("ERROR: No se encontró el campo STATUS en la respuesta.");
      }

      // actionCode
      if (jsonResponse.containsKey('actionCode')) {
        print("actionCode recibido: ${jsonResponse['actionCode']}");
        if (jsonResponse['actionCode'] == '000') {
          print("actionCode es válido: Aprobación confirmada.");
        } else {
          print(
              "actionCode inválido: Error en la autorización (${jsonResponse['actionCode']}).");
        }
      } else {
        print("ERROR: No se encontró el campo actionCode en la respuesta.");
      }

      // authorizationCode
      if (jsonResponse.containsKey('authorizationCode')) {
        print(
            "authorizationCode recibido: ${jsonResponse['authorizationCode']}");
        if (jsonResponse['authorizationCode'] != null) {
          print("authorizationCode es válido.");
        } else {
          print("authorizationCode es inválido: Campo vacío o nulo.");
        }
      } else {
        print(
            "ERROR: No se encontró el campo authorizationCode en la respuesta.");
      }

      // amount
      if (jsonResponse.containsKey('amount')) {
        print("amount recibido: ${jsonResponse['amount']}");
        if (jsonResponse['amount'] == requestedAmount) {
          print(
              "amount es válido: Coincide con el monto solicitado ($requestedAmount).");
        } else {
          print(
              "amount inválido: No coincide con el monto solicitado ($requestedAmount).");
        }
      } else {
        print("ERROR: No se encontró el campo amount en la respuesta.");
      }

      print("--- Fin de la Validación ---\n");
    } catch (e) {
      print("Excepción durante la validación de la respuesta: $e");
    }
  }
}
