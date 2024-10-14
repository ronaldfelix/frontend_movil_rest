import 'package:flutter/material.dart';
import '../../services/menu_service.dart';
import '../../config/config.dart';

class TopPedidos extends StatefulWidget {
  const TopPedidos({super.key});

  @override
  _TopPedidosState createState() => _TopPedidosState();
}

class _TopPedidosState extends State<TopPedidos> {
  late Future<List<dynamic>> _topPedidos;
  //Cargar top pedidos
  @override
  void initState() {
    super.initState();
    _topPedidos = MenuService().fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _topPedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los pedidos'));
        } else if (snapshot.hasData) {
          final topPedidos = snapshot.data!.take(5).toList(); // limitar lista

          return SizedBox(
            height: 150,
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
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
