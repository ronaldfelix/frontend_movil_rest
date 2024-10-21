import 'package:com_restaurante_frontend_movil/screens/orden_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String menu = '/menu';
  static const String order = '/order';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case order:
        return MaterialPageRoute(builder: (_) => const OrdenScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      // Aquí puedes agregar más rutas
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
