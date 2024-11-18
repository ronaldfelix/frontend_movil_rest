import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CurrentOrderWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(int, int) updateQuantity;
  final Function(int) removeFromCart;
  final Function() confirmOrder; // Se mantiene sin modificar
  final double total;
  final bool isLoggedIn;

  const CurrentOrderWidget({
    super.key,
    required this.cart,
    required this.updateQuantity,
    required this.removeFromCart,
    required this.confirmOrder,
    required this.total,
    required this.isLoggedIn,
  });

  void _handleOrderAction(BuildContext context) {
    if (isLoggedIn) {
      // Aquí se llama a `confirmOrder` directamente sin cambios
      confirmOrder();
    } else {
      final cartDetails = cart.isNotEmpty
          ? cart.take(5).map((item) {
              return 'Nombre: ${item['nombre']}, Cantidad: ${item['cantidad']}, Precio: S/.${item['precio']}';
            }).join("\n")
          : "Carrito vacío";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Código QR de tu pedido'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: QrImageView(
              data: cartDetails,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final pedido = cart[index];
              return ListTile(
                leading: Image.network(
                  pedido['imagen_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
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
                              updateQuantity(index, pedido['cantidad'] - 1);
                            }
                          },
                        ),
                        Text('${pedido['cantidad']}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            updateQuantity(index, pedido['cantidad'] + 1);
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFromCart(index),
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
                'Total: S/. ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _handleOrderAction(context),
                icon: const Icon(Icons.qr_code),
                label: const Text('Confirmar Orden'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
