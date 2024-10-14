import 'package:flutter/material.dart';
import '../widgets/menu_suggested.dart'; // Importa el widget de menú sugerido
import '../widgets/home_screen/menu_bar.dart'; // Importa la barra de menú

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 1; // Configura la pestaña activa en "Menú"

  // Manejar el cambio de pestañas desde el BottomMenuBar
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar a la pantalla correspondiente
    if (index == 0) {
      Navigator.pop(context); // Volver al HomeScreen
    }
    // Puedes añadir navegación a otras pestañas aquí si es necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Sugerido'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
      // Agrega la barra de menú en el MenuScreen
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _selectedIndex, // Muestra que la pestaña activa es "Menú"
        onTap: _onTabTapped, // Llama a la función para cambiar de pestaña
      ),
    );
  }
}
