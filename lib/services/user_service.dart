import 'package:http/http.dart' as http;
import 'dart:convert';

// Función para obtener el nombre del usuario
Future<String> fetchUserName(int userId) async {
  final url = Uri.parse(
      'http://192.168.1.200:8080/api/clientes/$userId'); // reemplazar 192.168.1.1200 x el de tu server (tu ip)

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
