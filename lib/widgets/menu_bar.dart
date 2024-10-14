import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
