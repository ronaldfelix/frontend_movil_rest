import 'package:com_restaurante_frontend_movil/services/search_service.dart';
import 'package:flutter/material.dart';
import '../widgets/menu_screen/menu_suggested.dart';
import '../widgets/menu_bar.dart';
import '../widgets/home_screen/search_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 1;
  String userName = "Usuario";

  // Cambiar pestañas
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar a pestaña anterior
    if (index == 0) {
      Navigator.pop(context);
    }
  }

  // Método de búsqueda
  Future<List<String>> _performSearch(String query) async {
    final results =
        await performSearch(query); // Realizar búsqueda en el backend
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Barra de búsqueda en la parte superior
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HomeSearchBar(
                onSearch: _performSearch, // Pasar la función de búsqueda
              ),
            ),
          ),
          // Contenido del Menú Sugerido
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 20),
                Text(
                  'Menú Sugerido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: MenuSuggested()), // Muestra el menú sugerido
              ],
            ),
          ),
          // Barra de búsqueda en la parte superior
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HomeSearchBar(
                onSearch: _performSearch, // Pasamos la función de búsqueda
              ),
            ),
          ),
        ],
      ),
      // Barra de menú en la parte inferior
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
