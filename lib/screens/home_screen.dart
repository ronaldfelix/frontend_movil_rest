import 'package:flutter/material.dart';
import '../widgets/home_screen/search_bar.dart';
import '../widgets/home_screen/offer_banner.dart';
import '../widgets/home_screen/top_pedidos.dart';
import '../widgets/menu_bar.dart';
import '../services/search_service.dart';
import '../services/user_service.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Usuario";
  int _selectedIndex = 0; //indice de ventanas

  @override
  void initState() {
    super.initState();
    _loadUserName();
  } //Cargar usuario al inicio

  Future<void> _loadUserName() async {
    final fetchedUserName = await fetchUserName(3);
    setState(() {
      userName = fetchedUserName;
    }); //hacer llamado a la bd para obtener un usuario
  }

  // enlistar busqueda
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

  // Cambiar de screen
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          if (_selectedIndex == 0) ...[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
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
                    const SizedBox(height: 30),
                    const Text(
                      'Ofertas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const OfferBanner(),
                    const SizedBox(height: 30),
                    const Text(
                      'Top Pedidos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TopPedidos(),
                  ],
                ),
              ),
            ),
          ],
          // Barra de búsqueda en la parte superior
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HomeSearchBar(
                onSearch: _onSearch,
              ),
            ),
          ),
          // Sugerencias de búsqueda
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
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped, // Cambiar de pestaña
      ),
    );
  }
}
