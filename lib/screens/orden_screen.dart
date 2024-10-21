import 'package:flutter/material.dart';
import '../widgets/menu_bar.dart'; // Asegúrate de tener el menú bar importado

class OrdenScreen extends StatefulWidget {
  static final List<Map<String, dynamic>> _cart = []; // Carrito estático

  // Método para añadir un platillo al carrito
  static void addToCart(Map<String, dynamic> pedido) {
    _cart.add(pedido);
  }

  const OrdenScreen({super.key});

  @override
  _OrdenScreenState createState() => _OrdenScreenState();
}

class _OrdenScreenState extends State<OrdenScreen> {
  // Método para calcular el total del carrito
  double _calculateTotal() {
    return OrdenScreen._cart.fold(0.0, (sum, item) => sum + item['precio']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            // Mostrar los ítems del carrito
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
                  subtitle: Text('S/. ${pedido['precio'].toString()}'),
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
                    // Aquí podrías agregar la lógica para finalizar la orden
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
        currentIndex: 2, // Índice para la pantalla de "Orden" (carrito)
      ),
    );
  }
}
