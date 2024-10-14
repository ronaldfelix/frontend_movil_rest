import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart'; // Importa la clase de configuración

// Función para obtener el nombre del usuario
Future<String> fetchUserName(int userId) async {
  // Usa la URL del servidor desde la clase Config
  final url = Uri.parse('${Config.baseUrl}/api/clientes/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes)); // Manejo de caracteres especiales
      return data['nombre'] as String; // Retorna el nombre del usuario
    } else {
      return "Usuario"; // Valor por defecto si falla
    }
  } catch (e) {
    return "Usuario"; // Valor por defecto en caso de error
  }
}
