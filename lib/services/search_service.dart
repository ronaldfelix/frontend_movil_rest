import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';

Future<List<String>> performSearch(String query) async {
  final url = Uri.parse('${Config.baseUrl}/api/menu/search?query=$query');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(
          utf8.decode(response.bodyBytes)); // Usar utf8.decode manejar tildes
      return data
          .map((item) => item['nombre'] as String)
          .toList(); // Mapear los resultados
    } else {
      return []; // Retornar una lista vacía si falla algp
    }
  } catch (e) {
    return []; // Retornar una lista vacía en caso de error
  }
}
