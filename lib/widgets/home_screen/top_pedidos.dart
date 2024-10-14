import 'package:flutter/material.dart';
import '../../services/menu_service.dart'; // Servicio para obtener el menú
import '../../config/config.dart'; // Configuración para la URL base

class TopPedidos extends StatefulWidget {
  const TopPedidos({super.key});

  @override
  _TopPedidosState createState() => _TopPedidosState();
}

class _TopPedidosState extends State<TopPedidos> {
  late Future<List<dynamic>> _topPedidos;

  @override
  void initState() {
    super.initState();
    _topPedidos = MenuService().fetchMenus(); // Obtener los menús de la API
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _topPedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Mostrar cargando
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar los pedidos')); // Mostrar error
        } else if (snapshot.hasData) {
          final topPedidos =
              snapshot.data!.take(5).toList(); // Limitar a 5 pedidos

          return SizedBox(
            height: 150, // Ajusta la altura según el contenido
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topPedidos.length,
              itemBuilder: (context, index) {
                final pedido = topPedidos[index];
                return _buildTopPedidoItem(pedido);
              },
            ),
          );
        } else {
          return const Center(child: Text('No se encontraron pedidos'));
        }
      },
    );
  }

  Widget _buildTopPedidoItem(dynamic pedido) {
    return Container(
      width: 120, // Ancho de cada ítem
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del pedido
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:
                    NetworkImage('${Config.baseUrl}/${pedido['imagen_url']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Nombre del pedido
          Text(
            pedido['nombre'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          // Precio del pedido
          Text(
            'S/. ${pedido['precio'].toString()}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
