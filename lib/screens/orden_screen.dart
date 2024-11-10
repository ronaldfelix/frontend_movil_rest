import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  // Generate the QR data with cart details
  String _generateQrData() {
    List<Map<String, dynamic>> cartDetails = OrdenScreen._cart.map((item) {
      return {
        'nombre': item['nombre'],
        'precio': item['precio'],
        'cantidad': item['cantidad'],
      };
    }).toList();

    return cartDetails.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mi orden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // Show a dialog with the QR code
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Código QR de la orden"),
                  content: SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: _generateQrData(),
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cerrar"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 2,
      ),
    );
  }
}
