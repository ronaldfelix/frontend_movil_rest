import 'package:com_restaurante_frontend_movil/screens/perfil_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/orden_screen.dart';

class BottomMenuBar extends StatelessWidget {
  final int currentIndex;

  const BottomMenuBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // Navegar según el índice
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrdenScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PerfilScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        _navigateToScreen(context, index); // Llamarfunción de navegación
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), label: 'Menu'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Orden'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black54,
    );
  }
}
