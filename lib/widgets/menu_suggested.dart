import 'package:flutter/material.dart';
import '../services/menu_service.dart'; // Importa el servicio de menú
import '../config/config.dart'; // Importa la clase de configuración

class MenuSuggested extends StatefulWidget {
  const MenuSuggested({super.key});

  @override
  _MenuSuggestedState createState() => _MenuSuggestedState();
}

class _MenuSuggestedState extends State<MenuSuggested> {
  late Future<List<dynamic>>
      _menus; // Almacenar la lista de menús que se cargará

  @override
  void initState() {
    super.initState();
    _menus =
        MenuService().fetchMenus(); // Cargar los menús al iniciar el widget
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _menus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Mostrar cargando
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar los menús')); // Mostrar error
        } else if (snapshot.hasData) {
          final menus = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Número de columnas
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75, // Ajuste de tamaño de los elementos
            ),
            itemCount: menus.length > 6
                ? 6
                : menus.length, // Limitar a 6 menús sugeridos
            itemBuilder: (context, index) {
              return _buildMenuSuggestedItem(menus[index]);
            },
          );
        } else {
          return const Center(
              child: Text('No se encontraron menús')); // Si no hay menús
        }
      },
    );
  }

  // Widget para construir un elemento del Menú Sugerido usando los datos del backend
  Widget _buildMenuSuggestedItem(dynamic menu) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: NetworkImage(
                    '${Config.baseUrl}/${menu['imagen_url']}'), // Construir la URL de imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              menu['nombre'], // Mostrar el nombre del menú
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${menu['precio'].toString()}', // Mostrar el precio del menú
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
