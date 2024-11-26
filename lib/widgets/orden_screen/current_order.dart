import 'package:flutter/material.dart';

class CurrentOrderWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(int, int) updateQuantity;
  final Function(int) removeFromCart;
  final Function() confirmOrder;
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
                onPressed: confirmOrder,
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
