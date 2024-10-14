import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';

class MenuService {
  Future<List<dynamic>> fetchMenus() async {
    final url = Uri.parse('${Config.baseUrl}/api/menu');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        throw Exception('Error al cargar el menú');
      }
    } catch (e) {
      throw Exception('Error al cargar el menú: $e');
    }
  }
}
