import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  final int currentIndex; // El índice de la pestaña seleccionada
  final ValueChanged<int>
      onTap; // Callback para manejar el toque en una pestaña

  const BottomMenuBar({
    Key? key,
    required this.currentIndex, // Asegura que el índice sea proporcionado
    required this.onTap, // Asegura que la función onTap sea proporcionada
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Muestra la pestaña seleccionada
      onTap: onTap, // Llama al callback cuando se toca una pestaña
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
