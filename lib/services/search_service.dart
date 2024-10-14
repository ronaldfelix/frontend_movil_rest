import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Importa la clase de configuración

// Función para realizar la búsqueda
Future<List<String>> performSearch(String query) async {
  // Construir la URL para la búsqueda usando la URL base
  final url = Uri.parse('${Config.baseUrl}/api/menu/search?query=$query');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8
          .decode(response.bodyBytes)); // Usar utf8.decode para manejar tildes
      return data
          .map((item) => item['nombre'] as String)
          .toList(); // Mapear los resultados
    } else {
      return []; // Retornar una lista vacía si falla
    }
  } catch (e) {
    return []; // Retornar una lista vacía en caso de error
  }
}
