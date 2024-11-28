// lib/services/niubiz_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class NiubizService {
  static Future<void> authorizeTransaction({
    required String purchaseNumber,
    required double amount,
  }) async {
    final url = Uri.parse(
        "http://192.168.1.200:8080/api/niubiz/generate-authorization-token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "purchaseNumber": purchaseNumber,
          "amount": amount.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Transacción autorizada con éxito: $jsonResponse");
      } else {
        print("Error al autorizar la transacción: ${response.body}");
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }
}
