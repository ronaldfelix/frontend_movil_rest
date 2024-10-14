import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Importa la clase de configuración

class MenuService {
  Future<List<dynamic>> fetchMenus() async {
    // Construir el endpoint usando la URL base de Config
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
