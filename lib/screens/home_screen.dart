import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/offer_banner.dart';
import '../widgets/menu_suggested.dart'; // Mantén la importación de MenuSuggested
import '../widgets/menu_bar.dart';
import '../services/search_service.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Usuario";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final fetchedUserName = await fetchUserName(3);
    setState(() {
      userName = fetchedUserName;
    });
  }

  // Método buscar
  List<String> _searchResults = [];
  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    final results = await performSearch(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          // Bienvenida + ofertas + menú sugerido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'BIENVENIDO(A)\n$userName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ofertas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const OfferBanner(), // Usa el widget OfferBanner
                  const SizedBox(height: 20),
                  const Text(
                    'Menú Sugerido',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const MenuSuggested(), // Usa el widget MenuSuggested actualizado
                ],
              ),
            ),
          ),
          // Barra de búsqueda en la parte superior
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: HomeSearchBar(
              onSearch: _onSearch,
            ),
          ),
          // Sugerencias de búsqueda que aparecen por encima
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: List.generate(_searchResults.length, (index) {
                      return ListTile(
                        leading: const Icon(Icons.search, color: Colors.grey),
                        title: Text(_searchResults[index]),
                        onTap: () {
                          print('Seleccionado: ${_searchResults[index]}');
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
        ],
      ),
      // Barra de menú inferior
      bottomNavigationBar: const BottomMenuBar(), // Usa el widget BottomMenuBar
    );
  }
}
