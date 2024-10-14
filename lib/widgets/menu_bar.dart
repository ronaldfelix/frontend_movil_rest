import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomMenuBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
