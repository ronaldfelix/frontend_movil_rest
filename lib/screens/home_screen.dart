import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Metodo buscar
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
          //Bienvenida+ofertas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Bienvenido Ronald',
                    style: TextStyle(
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
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage('assets/food.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 0 ? Colors.black : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Barra de búsqueda en la parte superior
          Positioned(
            top: 0,
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

      // Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Ayuda'),
        ],
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}
