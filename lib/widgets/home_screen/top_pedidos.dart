import 'package:flutter/material.dart';
import '../../services/menu_service.dart';
import '../../config/config.dart';
import '../../widgets/menu_detail_modal.dart';
import '../../screens/orden_screen.dart';

class TopPedidos extends StatefulWidget {
  const TopPedidos({super.key});

  @override
  _TopPedidosState createState() => _TopPedidosState();
}

class _TopPedidosState extends State<TopPedidos> {
  late Future<List<dynamic>> _topPedidos;

  // Cargar top pedidos
  @override
  void initState() {
    super.initState();
    _topPedidos = MenuService().fetchMenus();
  }

  // Función para abrir el modal
  void _showMenuDetail(BuildContext context, dynamic pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuDetailModal(
          pedido: pedido,
          // Añadir al carrito
          onAddToCart: () {
            OrdenScreen.addToCart({
              'nombre': pedido['nombre'],
              'imagen_url': '${Config.baseUrl}/${pedido['imagen_url']}',
              'precio': pedido['precio'],
            });
            Navigator.of(context).pop(); // Cerrar el modal

            // notificación de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Añadido'),
                duration: Durations.short3,
              ),
            );
          },
        );
      },
    );
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
          final topPedidos =
              snapshot.data!.take(5).toList(); // Limitar lista a 5

          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topPedidos.length,
              itemBuilder: (context, index) {
                final pedido = topPedidos[index];
                return GestureDetector(
                  onTap: () =>
                      _showMenuDetail(context, pedido), // Mostrar modal
                  child: _buildTopPedidoItem(pedido),
                );
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
          Text(
            pedido['nombre'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
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
