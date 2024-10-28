import 'package:flutter/material.dart';
import '../widgets/menu_bar.dart';

class OrdenScreen extends StatefulWidget {
  static final List<Map<String, dynamic>> _cart = [];

  // Método para añadir un platillo al carrito
  static void addToCart(Map<String, dynamic> pedido) {
    _cart.add({...pedido, 'cantidad': 1});
  }

  const OrdenScreen({super.key});

  @override
  _OrdenScreenState createState() => _OrdenScreenState();
}

class _OrdenScreenState extends State<OrdenScreen> {
  // Método para calcular el total del carrito
  double _calculateTotal() {
    return OrdenScreen._cart
        .fold(0.0, (sum, item) => sum + item['precio'] * item['cantidad']);
  }

  // Método para actualizar la cantidad
  void _updateQuantity(int index, int quantity) {
    setState(() {
      OrdenScreen._cart[index]['cantidad'] = quantity;
    });
  }

  // Eliminar un elemento del carrito
  void _removeFromCart(int index) {
    setState(() {
      OrdenScreen._cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mi orden'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: OrdenScreen._cart.length,
              itemBuilder: (context, index) {
                final pedido = OrdenScreen._cart[index];
                return ListTile(
                  leading: Image.network(
                    pedido['imagen_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(pedido['nombre']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('S/. ${pedido['precio'].toString()}'),
                      Row(
                        children: [
                          // Caja de cantidad
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (pedido['cantidad'] > 1) {
                                _updateQuantity(index, pedido['cantidad'] - 1);
                              }
                            },
                          ),
                          Text('${pedido['cantidad']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _updateQuantity(index, pedido['cantidad'] + 1);
                            },
                          ),
                          const Spacer(),
                          // Botón de eliminar
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFromCart(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Mostrar el total y el botón para confirmar la orden
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: S/. ${_calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Orden confirmada'),
                      ),
                    );
                  },
                  child: const Text('Confirmar Orden'),
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra de menú en la parte inferior
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 2,
      ),
    );
  }
}
