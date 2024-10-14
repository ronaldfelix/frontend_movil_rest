import 'package:flutter/material.dart';
import '../widgets/menu_screen/menu_suggested.dart';
import '../widgets/menu_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 1;

  // cambiar pestañas
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar a pestaña anterior
    if (index == 0) {
      Navigator.pop(context);
    }
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
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
