import 'package:http/http.dart' as http;
import 'dart:convert';

// Función para realizar la búsqueda
Future<List<String>> performSearch(String query) async {
  final url = Uri.parse(
      'http://192.168.1.200:8080/api/menu/search?query=$query'); // reemplazar 192.168.1.1200 x el de tu server (tu ip)
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => item['nombre'] as String).toList();
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
