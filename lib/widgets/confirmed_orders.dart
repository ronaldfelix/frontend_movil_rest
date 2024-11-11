import 'package:flutter/material.dart';
import 'qr_button.dart';

class ConfirmedOrdersWidget extends StatelessWidget {
  final List<List<Map<String, dynamic>>> confirmedOrders;
  final Function(int, int, int) updateQuantity;
  final Function(int, int) removeFromOrder;
  final Function(int) cancelOrder;
  final double Function(List<Map<String, dynamic>>) calculateTotal;

  const ConfirmedOrdersWidget({
    Key? key,
    required this.confirmedOrders,
    required this.updateQuantity,
    required this.removeFromOrder,
    required this.cancelOrder,
    required this.calculateTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: confirmedOrders.length,
      itemBuilder: (context, orderIndex) {
        final order = confirmedOrders[orderIndex];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Pedido ${orderIndex + 1} - Total: S/. ${calculateTotal(order).toStringAsFixed(2)}'),
                QRButton(order: order), // Add the QRButton for each order
              ],
            ),
            children: [
              Column(
                children: order.map((pedido) {
                  final index = order.indexOf(pedido);
                  return ListTile(
                    title: Text(pedido['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('S/. ${pedido['precio']}'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (pedido['cantidad'] > 1) {
                                  updateQuantity(orderIndex, index,
                                      pedido['cantidad'] - 1);
                                }
                              },
                            ),
                            Text('${pedido['cantidad']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                updateQuantity(
                                    orderIndex, index, pedido['cantidad'] + 1);
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  removeFromOrder(orderIndex, index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => cancelOrder(orderIndex),
                      child: const Text('Cancelar Orden',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
