import 'package:flutter/material.dart';
import '../widgets/home_screen/search_bar.dart';
import '../widgets/home_screen/offer_banner.dart';
import '../widgets/home_screen/top_pedidos.dart';
import '../widgets/menu_bar.dart';
import '../services/search_service.dart';
import '../services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Bienvenido(a)";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Cargar el nombre del usuario desde SQLite usando LoginService
  Future<void> _loadUserName() async {
    final user = await LoginService.getLoggedInUser();

    setState(() {
      userName = user?['nombre'] ??
          ""; // Si hay usuario, mostrar el nombre; si no, "Bienvenido(a)"
    });
  }

  // Método de búsqueda
  Future<List<String>> _performSearch(String query) async {
    return await performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
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
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HomeSearchBar(
                onSearch: _performSearch,
                onSelectedResult: (result) {
                  print("Resultado seleccionado: $result");
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 0,
      ),
    );
  }
}
