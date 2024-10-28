import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../widgets/menu_screen/menu_suggested.dart';
import '../widgets/menu_bar.dart';
import '../widgets/home_screen/search_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String userName = "Usuario";

  // Método de búsqueda
  Future<List<String>> _performSearch(String query) async {
    final results = await performSearch(query);
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
                onSearch: _performSearch,
              ),
            ),
          ),
          // Contenido del Menú Sugerido
          const Padding(
            padding: EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Menú Sugerido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: MenuSuggested()), // menú sugerido
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 1,
      ),
    );
  }
}
