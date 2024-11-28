import 'package:http/http.dart' as http;
import 'dart:convert';

class NiubizService {
  static Future<Map<String, dynamic>> authorizeTransaction({
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
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // Manejo del caso de error (código 400)
        final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
        errorResponse['statusCode'] = response.statusCode;
        return errorResponse;
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }
}
