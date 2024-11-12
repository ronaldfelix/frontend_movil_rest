import 'package:flutter/material.dart';
import '../../services/menu_service.dart';
import '../../config/config.dart';
import '../../widgets/menu_detail_modal.dart';
import '../../screens/orden_screen.dart';

class MenuSuggested extends StatefulWidget {
  const MenuSuggested({super.key});

  @override
  _MenuSuggestedState createState() => _MenuSuggestedState();
}

class _MenuSuggestedState extends State<MenuSuggested> {
  late Future<List<dynamic>> _menus;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _menus = MenuService().fetchMenus();
  }

  // Función para mostrar el modal de detalles del menú
  void _showMenuDetail(BuildContext context, dynamic menu) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuDetailModal(
          pedido: menu,
          onAddToCart: () {
            Navigator.of(context).pop(); // Cerrar el modal
            OrdenScreen.addToCart({
              'nombre': menu['nombre'],
              'imagen_url': '${Config.baseUrl}/${menu['imagen_url']}',
              'precio': menu['precio'],
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Añadido'),
                duration: Durations.short3,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _menus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los menús'));
        } else if (snapshot.hasData) {
          final menus = snapshot.data!;
          final displayMenus = _showAll ? menus : menus.take(6).toList();

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: displayMenus.length,
                  itemBuilder: (context, index) {
                    final menu = displayMenus[index];
                    return GestureDetector(
                      onTap: () => _showMenuDetail(context, menu),
                      child: _buildMenuSuggestedItem(menu),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                },
                child:
                    Text(_showAll ? 'Ver menú sugerido' : 'Ver menú completo'),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No se encontraron menús'));
        }
      },
    );
  }

  // Widget del "Menú sugerido"
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
                image: NetworkImage('${Config.baseUrl}/${menu['imagen_url']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              menu['nombre'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'S/ ${menu['precio'].toString()}',
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
