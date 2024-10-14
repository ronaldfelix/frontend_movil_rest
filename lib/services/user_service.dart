import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';

Future<String> fetchUserName(int userId) async {
  final url = Uri.parse('${Config.baseUrl}/api/clientes/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data['nombre'] as String;
    } else {
      return "Usuario";
    }
  } catch (e) {
    return "Usuario";
  }
}
